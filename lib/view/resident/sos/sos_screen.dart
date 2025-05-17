import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/controller/sos_management/sos_category/sos_category_cubit.dart';
import 'package:ghp_society_management/main.dart';
import 'package:ghp_society_management/view/resident/sos/sos_detail_screen.dart';
import 'package:ghp_society_management/view/resident/sos/sos_history.dart';
import 'package:ghp_society_management/view/session_dialogue.dart';
import 'package:google_fonts/google_fonts.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    await context.read<SosCategoryCubit>().fetchSosCategory();
  }

  Future<void> _onRefresh() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SosCategoryCubit, SosCategoryState>(
      listener: (context, state) {
        if (state is SosCategoryLogout) {
          sessionExpiredDialog(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'SOS',
            style: GoogleFonts.nunitoSans(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppTheme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SosHistoryPage()),
          ),
          child: const Icon(Icons.history, color: Colors.white),
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _onRefresh,
          color: AppTheme.primaryColor,
          backgroundColor: Colors.white,
          strokeWidth: 3.0,
          displacement: 40.0,
          edgeOffset: 0,
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<SosCategoryCubit, SosCategoryState>(
      builder: (context, state) {
        if (state is SosCategoryLoading && !_isRefreshing(state)) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SosCategorySearchLoaded) {
          return _buildSearchResults(state);
        } else if (state is SosCategoryLoaded) {
          return _buildCategoryGrid(state);
        } else if (state is SosCategoryFailed) {
          return _buildErrorState(state);
        } else if (state is SosCategoryInternetError) {
          return _buildInternetError();
        } else {
          return const SizedBox();
        }
      },
    );
  }

  bool _isRefreshing(SosCategoryState state) {
    // Check if we're in a refresh state (you might need to modify your cubit to track this)
    return false; // Modify based on your state implementation
  }

  Widget _buildSearchResults(SosCategorySearchLoaded state) {
    return state.sosCategory.isEmpty
        ? Center(
      child: Text(
        'Category Not Found!',
        style: TextStyle(
          color: Colors.deepPurpleAccent,
          fontSize: 16.sp,
        ),
      ),
    )
        : _buildMasonryGrid(state.sosCategory);
  }

  Widget _buildCategoryGrid(SosCategoryLoaded state) {
    return _buildMasonryGrid(state.sosCategory.first.data!.sosCategories);
  }

  Widget _buildMasonryGrid(List<dynamic> items) {
    return MasonryGridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 5,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 15.h),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (builder) => SosDetailScreen(sosCategory: item),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Container(
          decoration: BoxDecoration(
          color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 5,
              offset: Offset(1, 1)),
              ],
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: item.image,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, progress) => Center(
                  child: Image.asset(
                    width: 90,
                    height: 90,
                    'assets/images/default.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 90,
                  height: 90,
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.grey[600],
                    size: 50,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            item.name,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunitoSans(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ],
        ),
        );
      },
    );
  }

  Widget _buildErrorState(SosCategoryFailed state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.errorMsg.toString(),
            style: TextStyle(
              color: Colors.deepPurpleAccent,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: _onRefresh,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildInternetError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Internet connection error',
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: _onRefresh,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}