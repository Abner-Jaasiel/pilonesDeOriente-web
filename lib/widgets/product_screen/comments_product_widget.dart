import 'package:cached_network_image/cached_network_image.dart';
import 'package:carkett/generated/l10n.dart';
import 'package:carkett/models/product_model.dart';
import 'package:carkett/services/api_service.dart';
import 'package:carkett/widgets/alert_widget.dart';
import 'package:carkett/widgets/custom_textfield_widget.dart';
import 'package:carkett/widgets/super_progressindicator_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommentsProductWidget extends StatelessWidget {
  CommentsProductWidget({
    super.key,
    required this.product,
  });

  final ProductModel product;
  final TextEditingController commentController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet<void>(
          showDragHandle: true,
          useSafeArea: true,
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return product.comments.isEmpty
                ? BoxForCommentWidget(
                    commentController: commentController,
                    user: user,
                    product: product)
                : Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: DraggableScrollableSheet(
                      expand: false,
                      builder: (context, scrollController) {
                        return Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
                          ),
                          child: ListView.builder(
                            controller: scrollController,
                            shrinkWrap: true,
                            itemCount: product.comments.length,
                            itemBuilder: (context, index) {
                              final Widget comment = CommentCardWidget(
                                userId: product.comments[index].userId,
                                product: product,
                                userNameComment:
                                    product.comments[index].userNameComment,
                                comment: product.comments[index].comment,
                                backgroundImageUrl:
                                    product.comments[index].userProfileImage,
                              );

                              return Column(
                                children: [
                                  if (index == 0)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(S.current.comments,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium),
                                        const SizedBox(width: 10),
                                        Text(product.comments.length.toString())
                                      ],
                                    ),
                                  const SizedBox(height: 10),
                                  if (index == 0) const Divider(),
                                  if (index == 0)
                                    BoxForCommentWidget(
                                        commentController: commentController,
                                        user: user,
                                        product: product),
                                  if (product.comments[index].userNameComment
                                      .isNotEmpty)
                                    comment,
                                ],
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
          },
        );
      },
      child: Container(
        constraints: const BoxConstraints(maxHeight: 180, maxWidth: 800),
        margin: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Color.fromARGB(40, 142, 142, 142),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 5),
            Container(
              margin: const EdgeInsets.all(5),
              child: Text(S.current.comments),
            ),
            const Divider(),
            ListTile(
              leading: CircleAvatar(
                radius: 13,
                backgroundImage: product.comments.isNotEmpty &&
                        product.comments[0].userProfileImage != null
                    ? CachedNetworkImageProvider(
                        product.comments[0].userProfileImage!)
                    : const AssetImage("assets/images/profileUser.jpg")
                        as ImageProvider,
              ),
              title: Text(
                product.comments.isEmpty
                    ? "No Comments"
                    : product.comments[0].userNameComment,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                product.comments.isEmpty
                    ? "Be the first to comment!"
                    : product.comments[0].comment,
                maxLines: 4,
                overflow: TextOverflow.fade,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentCardWidget extends StatelessWidget {
  const CommentCardWidget({
    super.key,
    required this.product,
    required this.userNameComment,
    required this.comment,
    this.backgroundImageUrl,
    required this.userId,
  });

  final ProductModel product;
  final String? backgroundImageUrl;
  final String userNameComment;
  final String comment;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Card(
      // elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      // color: const Color.fromARGB(0, 142, 142, 142),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                GoRouter.of(context).push(
                  '/user_perfile',
                  extra: {
                    'isMy': false,
                    'userExternal': userId,
                  },
                );
              },
              child: CircleAvatar(
                radius: 13,
                backgroundImage: backgroundImageUrl != null
                    ? NetworkImage(
                        backgroundImageUrl!,
                      )
                    : const AssetImage("assets/images/profileUser.jpg"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userNameComment,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 7),
                  Text(
                    comment,
                    softWrap: true,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BoxForCommentWidget extends StatelessWidget {
  const BoxForCommentWidget({
    super.key,
    required this.commentController,
    required this.user,
    required this.product,
  });

  final TextEditingController commentController;
  final User? user;
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: CustomTextField(
                controller: commentController,
                hintText: S.current.comment,
                prefixIcon: Icons.comment_outlined,
                filled: true,
                obscureText: false,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: () async {
                if (commentController.text.isNotEmpty && user != null) {
                  progressIndicator(context);
                  await APIService().insertCommentToProduct(
                      product.id, user!, commentController.text);
                  commentController.clear();
                  Navigator.pop(context);
                } else {
                  if (user == null) {
                    alertWidget(context, S.current.error,
                        S.current.yourUserIsNotAuthenticated);
                  }
                }
              },
              child: const Icon(Icons.send),
            ),
          ),
        ],
      ),
    );
  }
}
