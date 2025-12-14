import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/models/itinerary_data.dart';
import 'package:tripora/core/models/lodging_data.dart';
import 'package:tripora/core/models/flight_data.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/utils/format_utils.dart';
import 'package:tripora/features/itinerary/views/widgets/activity_type_selection_sheet.dart';
import 'package:tripora/features/itinerary/views/widgets/add_edit_itinerary_bottom_sheet.dart';
import 'package:tripora/features/itinerary/views/widgets/add_edit_lodging_bottom_sheet.dart';
import 'package:tripora/features/itinerary/views/widgets/add_edit_flight_bottom_sheet.dart';
import 'package:tripora/features/itinerary/viewmodels/itinerary_view_model.dart';
import 'package:tripora/features/itinerary/viewmodels/post_itinerary_view_model.dart';
import 'package:tripora/features/itinerary/viewmodels/weather_viewmodel.dart';
import 'package:tripora/features/itinerary/views/widgets/itinerary_item.dart';
import 'package:tripora/features/itinerary/views/widgets/lodging_card.dart';
import 'package:tripora/features/itinerary/views/widgets/flight_card.dart';
import 'package:tripora/features/itinerary/views/widgets/weather_card.dart';

@immutable
class _DraggedItinerary {
  const _DraggedItinerary({required this.itinerary, required this.fromDay});
  final ItineraryData itinerary;
  final int fromDay;
}

class MultiDayItineraryList extends StatefulWidget {
  const MultiDayItineraryList({
    super.key,
    required this.scrollController,
    this.isViewMode = false,
  });

  final ScrollController scrollController;
  final bool isViewMode;

  @override
  State<MultiDayItineraryList> createState() => MultiDayItineraryListState();
}

class MultiDayItineraryListState extends State<MultiDayItineraryList> {
  final Map<int, GlobalKey> _dayKeys = {}; // For scroll linking

  void scrollToDay(int day) {
    final keyContext = _dayKeys[day]?.currentContext;
    if (keyContext != null) {
      Scrollable.ensureVisible(
        keyContext,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherVm = context.watch<WeatherViewModel>();

    // Get data based on view mode
    final Map<int, List<dynamic>> itinerariesMap;
    final Map<int, List<dynamic>> lodgingsMap;
    final Map<int, List<dynamic>> flightsMap;
    final DateTime? tripStartDate;
    final dynamic vm; // Keep vm for edit mode operations
    final bool isLoading;

    if (widget.isViewMode) {
      final postVm = context.watch<PostItineraryViewModel>();
      itinerariesMap = postVm.itinerariesMap.cast<int, List<dynamic>>();
      lodgingsMap = postVm.lodgingsMap.cast<int, List<dynamic>>();
      flightsMap = postVm.flightsMap.cast<int, List<dynamic>>();
      tripStartDate = postVm.trip?.startDate;
      isLoading = postVm.isLoading;
      vm = postVm; // For compatibility
      debugPrint('🎨 MultiDayItineraryList building in VIEW MODE:');
      debugPrint('   - isLoading: $isLoading');
      debugPrint('   - itinerariesMap.keys: ${itinerariesMap.keys.toList()}');
      debugPrint('   - itinerariesMap.isEmpty: ${itinerariesMap.isEmpty}');
      debugPrint('   - tripStartDate: $tripStartDate');
    } else {
      final itineraryVm = context.watch<ItineraryViewModel>();
      itinerariesMap = itineraryVm.itinerariesMap.cast<int, List<dynamic>>();
      lodgingsMap = itineraryVm.lodgingsMap.cast<int, List<dynamic>>();
      flightsMap = itineraryVm.flightsMap.cast<int, List<dynamic>>();
      tripStartDate = itineraryVm.trip?.startDate;
      isLoading = false; // ItineraryViewModel loads data differently
      vm = itineraryVm;
    }

    // Show loading indicator while data is being fetched
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Handle empty state or null data
    if (itinerariesMap.isEmpty || tripStartDate == null) {
      debugPrint(
        '⚠️ Showing empty state: isEmpty=${itinerariesMap.isEmpty}, tripStartDate=$tripStartDate',
      );
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('No itinerary data available'),
        ),
      );
    }

    return Column(
      children: List.generate(itinerariesMap.keys.length, (dayIndex) {
        final day = itinerariesMap.keys.elementAt(dayIndex);
        final items = itinerariesMap[day]!;

        _dayKeys[day] = GlobalKey();

        return DragTarget<_DraggedItinerary>(
          key: _dayKeys[day],
          onAcceptWithDetails: widget.isViewMode
              ? null
              : (details) {
                  final dragged = details.data;
                  // Append to end of the target day for simplicity. Users can reorder within day afterwards.
                  final insertIndex = vm.itinerariesMap[day]?.length ?? 0;
                  vm.moveItemBetweenDays(
                    dragged.fromDay,
                    day,
                    dragged.itinerary,
                    insertIndex,
                  );
                },
          onWillAcceptWithDetails: widget.isViewMode
              ? null
              : (details) {
                  // Accept drops from other days only to avoid redundant moves
                  return details.data.fromDay != day;
                },
          builder: (context, candidateData, rejectedData) {
            final dayWeatherForecast = (weatherVm.dailyForecasts.length >= day)
                ? weatherVm.dailyForecasts[day - 1]
                : null;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    "Day $day • ${getFormattedDayLabel(day, itinerariesMap.keys.length, tripStartDate!)}",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: ManropeFontWeight.semiBold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // ----- Weather card
                if (dayWeatherForecast == null)
                  WeatherCard(condition: "", temperature: 0.0, lastUpdated: "")
                else if (dayWeatherForecast.condition != "Unknown" &&
                    dayWeatherForecast.temperature != 0.0)
                  WeatherCard(
                    condition: dayWeatherForecast.condition,
                    temperature: dayWeatherForecast.temperature,
                    lastUpdated: "Updated just now",
                  )
                else
                  const SizedBox(height: 0),
                const SizedBox(height: 16),

                // ----- Lodging cards -----
                ...(lodgingsMap[day] ?? []).map(
                  (lodging) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: LodgingCard(
                      lodging: lodging,
                      onTap: widget.isViewMode
                          ? null
                          : () async {
                              final result = await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (_) =>
                                    AddEditLodgingBottomSheet(lodging: lodging),
                              );

                              if (result == null || !mounted) return;

                              try {
                                if (result == 'delete') {
                                  await vm.deleteLodging(lodging.id);
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Lodging "${lodging.name}" deleted successfully',
                                        ),
                                      ),
                                    );
                                  }
                                } else if (result is LodgingData) {
                                  await vm.updateLodging(result);
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Lodging "${result.name}" updated successfully',
                                        ),
                                      ),
                                    );
                                  }
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Failed to update lodging: $e',
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                    ),
                  ),
                ),

                // ----- Flight cards -----
                ...(flightsMap[day] ?? []).map(
                  (flight) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: FlightCard(
                      flight: flight,
                      onTap: widget.isViewMode
                          ? null
                          : () async {
                              final result = await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (_) =>
                                    AddEditFlightBottomSheet(flight: flight),
                              );

                              if (result == null || !mounted) return;

                              try {
                                if (result == 'delete') {
                                  await vm.deleteFlight(flight.id);
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Flight "${flight.airline}" deleted successfully',
                                        ),
                                      ),
                                    );
                                  }
                                } else if (result is FlightData) {
                                  await vm.updateFlight(result);
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Flight "${result.airline}" updated successfully',
                                        ),
                                      ),
                                    );
                                  }
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Failed to update flight: $e',
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                    ),
                  ),
                ),

                // ----- Itinerary items -----
                // Use ReorderableListView in edit mode, ListView in view mode
                if (widget.isViewMode)
                  ListView.builder(
                    padding: const EdgeInsets.only(top: 20, bottom: 30),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      // Calculate destination number (exclude notes from numbering)
                      final destinationIndex = items
                          .sublist(0, index)
                          .where((i) => i.isDestination)
                          .length;
                      // Use a unique key for proper widget identity
                      final uniqueKey = item.id.isEmpty
                          ? ValueKey(
                              'day${day}_idx${index}_${item.placeId}_${item.sequence}',
                            )
                          : ValueKey(item.id);
                      return GestureDetector(
                        key: uniqueKey,
                        onTap: null, //         No tap action in view mode
                        child: ItineraryItem(
                          itinerary: item,
                          isFirst: index == 0,
                          isLast: index == items.length - 1,
                          index: destinationIndex,
                          // No drag handle in view mode
                          showDragHandle: !widget.isViewMode,
                        ),
                      );
                    },
                  )
                else
                  ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    onReorder: (oldIndex, newIndex) =>
                        vm.reorderWithinDay(day, oldIndex, newIndex),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      // Calculate destination number (exclude notes from numbering)
                      final destinationIndex = items
                          .sublist(0, index)
                          .where((i) => i.isDestination)
                          .length;
                      // Each item is both draggable and a drop target
                      // Use a unique key combining day, index, and id to handle items without IDs
                      final uniqueKey = item.id.isEmpty
                          ? ValueKey(
                              'day${day}_idx${index}_${item.placeId}_${item.sequence}',
                            )
                          : ValueKey(item.id);
                      return DragTarget<_DraggedItinerary>(
                        key: uniqueKey,
                        builder: (context, candidateData, rejectedData) {
                          final isActive = candidateData.isNotEmpty;
                          // Highlight drop target when active
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Highlight drop target when active
                              if (isActive)
                                Container(
                                  height: 12,
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.12),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(6),
                                    ),
                                  ),
                                ),
                              // The actual itinerary item with drag handle
                              Stack(
                                children: [
                                  // The itinerary item card
                                  GestureDetector(
                                    onTap: widget.isViewMode
                                        ? null
                                        : () {
                                            _openEditItinerarySheet(
                                              context,
                                              item,
                                              vm,
                                            );
                                          },
                                    child: ItineraryItem(
                                      itinerary: item,
                                      isFirst: index == 0,
                                      isLast: index == items.length - 1,
                                      index: destinationIndex,
                                    ),
                                  ),
                                  // The drag handle (hidden in view mode)
                                  if (!widget.isViewMode)
                                    Positioned(
                                      right: 8,
                                      top: 8,
                                      // Using LongPressDraggable for better UX
                                      child:
                                          LongPressDraggable<_DraggedItinerary>(
                                            data: _DraggedItinerary(
                                              itinerary: item,
                                              fromDay: day,
                                            ),
                                            feedback: Material(
                                              elevation: 6,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: ConstrainedBox(
                                                constraints:
                                                    const BoxConstraints(
                                                      maxWidth: 360,
                                                    ),
                                                child: Opacity(
                                                  opacity: 0.95,
                                                  child: ItineraryItem(
                                                    itinerary: item,
                                                    isFirst: true,
                                                    isLast: true,
                                                    index: index,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            childWhenDragging: Opacity(
                                              opacity: 0.3,
                                              child: Icon(
                                                Icons.open_with,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                                size: 12,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.open_with,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withOpacity(0.6),
                                              size: 16,
                                            ),
                                          ),
                                    ),
                                ],
                              ),
                            ],
                          );
                        },
                        onWillAcceptWithDetails: widget.isViewMode
                            ? null
                            : (details) {
                                return details.data.fromDay != day;
                              },
                        onAcceptWithDetails: widget.isViewMode
                            ? null
                            : (details) {
                                if (!mounted) return;
                                final dragged = details.data;
                                vm.moveItemBetweenDays(
                                  dragged.fromDay,
                                  day,
                                  dragged.itinerary,
                                  index,
                                );
                              },
                      );
                    },
                  ),
                const SizedBox(height: 16),
                if (!widget.isViewMode)
                  AppButton.textOnly(
                    text: 'Add Activity',
                    radius: 10,
                    minWidth: double.infinity,
                    minHeight: 36,
                    backgroundVariant: BackgroundVariant.primaryTrans,
                    onPressed: () async {
                      final activityType =
                          await showModalBottomSheet<ActivityType>(
                            context: context,
                            builder: (context) =>
                                const ActivityTypeSelectionSheet(),
                          );

                      if (activityType == null) return;

                      switch (activityType) {
                        case ActivityType.destination:
                          final draftItinerary = ItineraryData.empty(
                            vm.getDate(day),
                            vm.getLastSequence(day),
                          );
                          _openEditItinerarySheet(context, draftItinerary, vm);
                          break;
                        case ActivityType.lodging:
                          final draftLodging = LodgingData.empty(
                            vm.getDate(day),
                            vm.getLastSequence(day),
                          );
                          final result =
                              await showModalBottomSheet<LodgingData>(
                                context: context,
                                isScrollControlled: true,
                                builder: (_) => AddEditLodgingBottomSheet(
                                  lodging: draftLodging,
                                ),
                              );
                          if (result != null && mounted) {
                            try {
                              await vm.addLodging(result);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Lodging "${result.name}" added successfully',
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to add lodging: $e'),
                                  ),
                                );
                              }
                            }
                          }
                          break;
                        case ActivityType.flight:
                          final draftFlight = FlightData.empty(
                            vm.getDate(day),
                            vm.getLastSequence(day),
                          );
                          final result = await showModalBottomSheet<FlightData>(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) =>
                                AddEditFlightBottomSheet(flight: draftFlight),
                          );
                          if (result != null && mounted) {
                            try {
                              await vm.addFlight(result);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Flight "${result.airline}" added successfully',
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to add flight: $e'),
                                  ),
                                );
                              }
                            }
                          }
                          break;
                        case ActivityType.notes:
                          final draftNote = ItineraryData.emptyNote(
                            vm.getDate(day),
                            vm.getLastSequence(day),
                          );
                          final result =
                              await showModalBottomSheet<ItineraryData>(
                                context: context,
                                isScrollControlled: true,
                                builder: (_) => ChangeNotifierProvider.value(
                                  value: vm,
                                  child: AddEditItineraryBottomSheet(
                                    itinerary: draftNote,
                                  ),
                                ),
                              );
                          if (result != null && mounted) {
                            try {
                              vm.addItinerary(result);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Note added successfully'),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to add note: $e'),
                                  ),
                                );
                              }
                            }
                          }
                          break;
                      }
                    },
                  ),
                // Only add spacing in edit mode for the "Add Activity" button area
                if (!widget.isViewMode) const SizedBox(height: 24),
                // Trailing drop target to append at end of day
                if (!widget.isViewMode)
                  DragTarget<_DraggedItinerary>(
                    builder: (context, candidateData, rejectedData) {
                      final isActive = candidateData.isNotEmpty;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 120),
                        height: isActive ? 16 : 8,
                        margin: const EdgeInsets.only(top: 8, bottom: 4),
                        decoration: isActive
                            ? BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.12),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6),
                                ),
                              )
                            : null,
                      );
                    },
                    onWillAcceptWithDetails: widget.isViewMode
                        ? null
                        : (details) {
                            return details.data.fromDay != day;
                          },
                    onAcceptWithDetails: widget.isViewMode
                        ? null
                        : (details) {
                            final dragged = details.data;
                            final insertIndex =
                                vm.itinerariesMap[day]?.length ?? 0;
                            vm.moveItemBetweenDays(
                              dragged.fromDay,
                              day,
                              dragged.itinerary,
                              insertIndex,
                            );
                          },
                  ),
              ],
            );
          },
        );
      }),
    );
  }

  void _openEditItinerarySheet(
    BuildContext context,
    ItineraryData? itinerary,
    dynamic viewModel,
  ) {
    final vm = viewModel is ItineraryViewModel
        ? viewModel
        : context.read<ItineraryViewModel>();

    // Reset and populate if editing
    vm.clearForm();
    if (itinerary != null) {
      vm.populateFromItinerary(itinerary);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: vm,
        child: AddEditItineraryBottomSheet(itinerary: itinerary),
      ),
    );
  }
}
