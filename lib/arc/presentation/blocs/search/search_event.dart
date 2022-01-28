part of 'search_bloc.dart';
abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class OnSearchEvent extends SearchEvent {
  final String keyword;
  const OnSearchEvent(this.keyword);
}

class OnFollowClickedEvent extends SearchEvent{
  final String userId;
  const OnFollowClickedEvent(this.userId);
}
