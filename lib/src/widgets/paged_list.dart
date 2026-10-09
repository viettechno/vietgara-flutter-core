import 'dart:async';

import 'package:flutter/material.dart';

import '../api/page.dart';
import 'common.dart';
import 'vg.dart';

/// An infinite, pull-to-refresh list over a paginated endpoint. Changing
/// [query] (a search text, a filter) reloads from the first page; so does
/// [PagedListViewState.reload].
class PagedListView<T> extends StatefulWidget {
  const PagedListView({
    super.key,
    required this.fetch,
    required this.itemBuilder,
    required this.itemKey,
    required this.emptyMessage,
    this.emptyIcon = Icons.inbox_outlined,
    this.query,
    this.separated = true,
  });

  final Future<ResultPage<T>> Function(int page) fetch;
  final Widget Function(BuildContext context, T item) itemBuilder;

  /// A stable identity of an item (its id), so rows keep their state and
  /// element when items are inserted or a page is prepended.
  final Object Function(T item) itemKey;
  final String emptyMessage;
  final IconData emptyIcon;
  final Object? query;
  final bool separated;

  @override
  State<PagedListView<T>> createState() => PagedListViewState<T>();
}

class PagedListViewState<T> extends State<PagedListView<T>> {
  final _scroll = ScrollController();
  final _items = <T>[];
  int _page = 0;
  bool _hasMore = true;
  bool _loading = false;
  Object? _error;

  /// Guards against answers of a superseded load (an older query).
  int _generation = 0;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    unawaited(_loadMore());
  }

  @override
  void didUpdateWidget(PagedListView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) unawaited(reload());
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scroll.position.extentAfter < 400) unawaited(_loadMore());
  }

  Future<void> reload() {
    _generation++;
    setState(() {
      _items.clear();
      _page = 0;
      _hasMore = true;
      _loading = false;
      _error = null;
    });
    return _loadMore();
  }

  Future<void> _loadMore() async {
    if (_loading || !_hasMore) return;
    final generation = _generation;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page = await widget.fetch(_page + 1);
      if (!mounted || generation != _generation) return;
      setState(() {
        _items.addAll(page.items);
        _page = page.page;
        _hasMore = page.hasMore;
      });
    } catch (error) {
      if (mounted && generation == _generation) {
        setState(() => _error = error);
      }
    } finally {
      if (mounted && generation == _generation) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget child;
    if (_items.isEmpty && _error != null) {
      child = ListView(
        children: [
          const SizedBox(height: 80),
          ErrorView(error: _error!, onRetry: _loadMore),
        ],
      );
    } else if (_items.isEmpty && !_hasMore) {
      child = ListView(
        children: [
          const SizedBox(height: 80),
          MessageView(icon: widget.emptyIcon, message: widget.emptyMessage),
        ],
      );
    } else if (_items.isEmpty) {
      child = const SkeletonList();
    } else {
      final footer = _hasMore || _error != null ? 1 : 0;
      child = ListView.separated(
        controller: _scroll,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 88),
        itemCount: _items.length + footer,
        separatorBuilder: (_, _) => widget.separated
            ? const Divider(height: 1)
            : const SizedBox.shrink(),
        itemBuilder: (context, index) {
          if (index < _items.length) {
            final item = _items[index];
            return KeyedSubtree(
              key: ValueKey(widget.itemKey(item)),
              child: widget.itemBuilder(context, item),
            );
          }
          if (_error != null) {
            return TextButton(
              onPressed: _loadMore,
              child: Text(context.coreL10n.actionRetry),
            );
          }
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        },
      );
    }
    return RefreshIndicator(onRefresh: reload, child: child);
  }
}

/// A search field for the top of a list screen; [onChanged] gets the trimmed
/// text once typing pauses.
class SearchField extends StatefulWidget {
  const SearchField({super.key, required this.hint, required this.onChanged});

  final String hint;
  final ValueChanged<String> onChanged;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
    child: SearchBar(
      hintText: widget.hint,
      leading: const Icon(Icons.search, size: 20),
      elevation: const WidgetStatePropertyAll(0),
      onChanged: (text) {
        _debounce?.cancel();
        _debounce = Timer(
          const Duration(milliseconds: 350),
          () => widget.onChanged(text.trim()),
        );
      },
    ),
  );
}
