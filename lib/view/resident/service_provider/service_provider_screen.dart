import 'package:cached_network_image/cached_network_image.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/view/resident/service_provider/service_provider_detail_screen.dart';

class ServiceProviderScreen extends StatefulWidget {
  const ServiceProviderScreen({super.key});

  @override
  State<ServiceProviderScreen> createState() => _ServiceProviderScreenState();
}

class _ServiceProviderScreenState extends State<ServiceProviderScreen> {
  TextEditingController textController = TextEditingController();
  bool searchBarOpen = false;

  @override
  void initState() {
    context.read<ServiceCategoriesCubit>().fetchServiceCategories();
    super.initState();
  }

  Future onRefresh()async{
    context.read<ServiceCategoriesCubit>().fetchServiceCategories();

  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServiceCategoriesCubit, ServiceCategoriesState>(
      listener: (context, state) {
        if (state is ServiceCategoriesLogout) {
          sessionExpiredDialog(context);
        }
      },
      child: Scaffold(
        appBar: customAppbar(
          context: context,
          title: 'Service Category',
          textController: textController,
          searchBarOpen: searchBarOpen,
          onExpansionComplete: () {
            setState(() {
              searchBarOpen = true;
            });
          },
          onCollapseComplete: () {
            setState(() {
              searchBarOpen = false;
              context.read<ServiceCategoriesCubit>().fetchServiceCategories();
              textController.clear();
            });
          },
          onPressButton: (isSearchBarOpens) {
            setState(() {
              searchBarOpen = true;
            });
          },
          onChanged: (value) {
            context.read<ServiceCategoriesCubit>().searchServiceCategory(value);
          },
        ),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: BlocBuilder<ServiceCategoriesCubit, ServiceCategoriesState>(
            builder: (context, state) {
              if (state is ServiceCategoriesLoaded) {
                return GridView.builder(
                    padding: const EdgeInsets.only(top: 15),
                    itemCount: state
                        .serviceCategories.first.data.serviceCategories.length,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 10, crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (builder) => ServiceProviderDetailScreen(
                                    categoryId: state.serviceCategories.first.data
                                        .serviceCategories[index].id
                                        .toString(),
                                  )));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: state.serviceCategories.first.data
                                    .serviceCategories[index].image
                                    .toString(),
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                                progressIndicatorBuilder:
                                    (context, url, progress) => Center(
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
                            Text(
                                state.serviceCategories.first.data
                                    .serviceCategories[index].name,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.black,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                          ],
                        ),
                      );
                    });
              } else if (state is ServiceCategoriesSearchLoaded) {
                return state.serviceCategories.isEmpty
                    ? const Center(
                        child: Text('No Service provider Found',
                            style: TextStyle(color: Colors.deepPurpleAccent)))
                    : GridView.builder(
                        padding: const EdgeInsets.only(top: 15),
                        itemCount: state.serviceCategories.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 10, crossAxisCount: 3),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (builder) =>
                                      ServiceProviderDetailScreen(
                                          categoryId: state
                                              .serviceCategories[index].id
                                              .toString())));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: state.serviceCategories[index].image
                                        .toString(),
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder:
                                        (context, url, progress) => Center(
                                      child: Image.asset(
                                        width: 90,
                                        height: 90,
                                        'assets/images/default.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
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
                                Text(
                                  state.serviceCategories[index].name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.black,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          );
                        });
              } else if (state is ServiceCategoriesFailed) {
                return emptyDataWidget(
                    state.errorMsg.toString()); // Handle error state
              } else if (state is ServiceCategoriesLoading) {
                return gridviewSimmerLoading(context); // Handle error state
              } else if (state is ServiceCategoriesInternetError) {
                return const Center(
                    child: Text('Internet connection error',
                        style: TextStyle(
                            color: Colors.red))); // Handle internet error
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}
