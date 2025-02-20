import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carkett/generated/l10n.dart';
import 'package:carkett/models/product_model.dart';
import 'package:carkett/models/user_model.dart';
import 'package:carkett/services/api_service.dart';
import 'package:carkett/utils/utils.dart';
import 'package:carkett/widgets/alert_widget.dart';
import 'package:carkett/widgets/custom_textfield_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CommentsProductWidget extends StatefulWidget {
  const CommentsProductWidget({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  _CommentsProductWidgetState createState() => _CommentsProductWidgetState();
}

class _CommentsProductWidgetState extends State<CommentsProductWidget> {
  final TextEditingController commentController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;

  bool isLoading = false;

  void _deleteComment(int commentId) async {
    setState(() {
      isLoading = true;
    });

    try {
      await APIService().deleteCommentFromProduct(commentId);
      setState(() {
        widget.product.comments
            .removeWhere((comment) => comment.id == commentId);
        isLoading = false;
      });
    } catch (e) {
      print("Error al eliminar el comentario: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Map> newCommets = [];
  Future _addComment(String commentText) async {
    if (user != null) {
      try {
        CommentModel newComment = CommentModel(
            id: DateTime.now().millisecondsSinceEpoch,
            productId: widget.product.id,
            userId: user!.uid,
            comment: commentText,
            userNameComment: user!.displayName ?? "Anonymous",
            userProfileImage: user!.photoURL,
            createdAt: DateTime.now());

        // widget.product.comments.add(newComment);
        newCommets.add({
          "userName": user!.displayName,
          "comment": commentText,
          "userProfileImage": user!.photoURL,
          "createdAt": DateTime.now()
        });
        await APIService().insertCommentToProduct(
          widget.product.id,
          user!,
          commentText,
        );

        print(
            "Comentario insertado: ${newComment.comment} - ID: ${newComment.id}");
      } catch (e) {
        print("Error al agregar comentario: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: user != null
            ? loadUserFromPreferences(user!.uid)
            : loadExternalUser(widget.product.sellerfirebaseUid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null) {
            return const Center(child: Text('No userdata available.'));
          }
          UserModel dataUser = snapshot.data as UserModel;
          return GestureDetector(
            onTap: () {
              showModalBottomSheet<void>(
                showDragHandle: true,
                useSafeArea: true,
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, setState) {
                      return widget.product.comments.isEmpty &&
                              newCommets.isEmpty
                          ? BoxForCommentWidget(
                              commentController: commentController,
                              user: user,
                              product: widget.product,
                              onCommentAdded: (newCommentText) async {
                                await _addComment(newCommentText);
                                setState(() {});
                              },
                            )
                          : Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom /
                                        1.4,
                              ),
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
                                    child: ListView(
                                      children: [
                                        // if (index == 0)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(S.current.comments,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium),
                                            const SizedBox(width: 10),
                                            Text(widget.product.comments.length
                                                .toString())
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        //   if (index == 0) const Divider(),
                                        //  if (index == 0)
                                        BoxForCommentWidget(
                                          commentController: commentController,
                                          user: user,
                                          product: widget.product,
                                          onCommentAdded:
                                              (newCommentText) async {
                                            await _addComment(newCommentText);
                                            setState(() {});
                                          },
                                        ),

                                        ListView.builder(
                                            controller: scrollController,
                                            shrinkWrap: true,
                                            itemCount: newCommets.length,
                                            itemBuilder: (context, ind) {
                                              return CommentCardWidget(
                                                product: widget.product,
                                                userNameComment: dataUser.name,
                                                backgroundImageUrl:
                                                    dataUser.profileImageUrl,
                                                comment: newCommets[ind]
                                                    ["comment"],
                                                userId: user!.uid,
                                                createdAt: newCommets[ind]
                                                    ["createdAt"],
                                              );
                                            }),
                                        ListView.builder(
                                          controller: scrollController,
                                          shrinkWrap: true,
                                          itemCount:
                                              widget.product.comments.length,
                                          itemBuilder: (context, index) {
                                            Widget comment = CommentCardWidget(
                                              userId: widget.product
                                                  .comments[index].userId,
                                              product: widget.product,
                                              userNameComment: widget
                                                  .product
                                                  .comments[index]
                                                  .userNameComment,
                                              comment: widget.product
                                                  .comments[index].comment,
                                              backgroundImageUrl: widget
                                                  .product
                                                  .comments[index]
                                                  .userProfileImage,
                                              createdAt: widget.product
                                                  .comments[index].createdAt,
                                            );

                                            if (user != null &&
                                                widget.product.comments[index]
                                                        .userId ==
                                                    user!.uid) {
                                              comment = InkWell(
                                                onLongPress: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            "Eliminar"),
                                                        content: const Text(
                                                            "¿Desea eliminar el comentario?"),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: Text(
                                                                S.current.no),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                          TextButton(
                                                            child: Text(
                                                                S.current.yes),
                                                            onPressed:
                                                                () async {
                                                              _deleteComment(
                                                                  widget
                                                                      .product
                                                                      .comments[
                                                                          index]
                                                                      .id);
                                                              setState(() {
                                                                widget.product
                                                                    .comments
                                                                    .removeAt(
                                                                        index);
                                                              });
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: comment,
                                              );
                                            }

                                            return Column(
                                              children: [
                                                if (widget
                                                    .product
                                                    .comments[index]
                                                    .userNameComment
                                                    .isNotEmpty)
                                                  comment,
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                    },
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
                  Container(
                    margin: const EdgeInsets.all(5),
                    child: Text(S.current.comments),
                  ),
                  const Divider(),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 13,
                      backgroundImage: widget.product.comments.isNotEmpty &&
                              widget.product.comments[0].userProfileImage !=
                                  null
                          ? CachedNetworkImageProvider(
                              widget.product.comments[0].userProfileImage!)
                          : const AssetImage("assets/images/profileUser.jpg")
                              as ImageProvider,
                    ),
                    title: Text(
                      widget.product.comments.isEmpty
                          ? "No Comments"
                          : widget.product.comments[0].userNameComment,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      widget.product.comments.isEmpty
                          ? "Be the first to comment!"
                          : widget.product.comments[0].comment,
                      maxLines: 4,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
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
    required this.createdAt, // Añadido para la fecha
  });

  final ProductModel product;
  final String? backgroundImageUrl;
  final String userNameComment;
  final String comment;
  final String userId;
  final DateTime createdAt; // Fecha y hora del comentario

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                GoRouter.of(context).push(
                  '/user_perfile/false/$userId',
                );
              },
              child: CircleAvatar(
                radius: 13,
                backgroundImage: backgroundImageUrl != null
                    ? NetworkImage(backgroundImageUrl!)
                    : const AssetImage("assets/images/profileUser.jpg"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userNameComment,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 7),
                  Text(
                    comment,
                    softWrap: true,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 7),
                  Text(
                    _formatDate(createdAt), // Mostrar la fecha y hora
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey), // Estilo de fecha
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para formatear la fecha y hora
  String _formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(dateTime);
  }
}

class BoxForCommentWidget extends StatelessWidget {
  const BoxForCommentWidget({
    super.key,
    required this.commentController,
    required this.user,
    required this.product,
    required this.onCommentAdded,
  });

  final TextEditingController commentController;
  final User? user;
  final ProductModel product;
  final Function(String) onCommentAdded;

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
                  final commentText = commentController.text;
                  commentController.clear();
                  // Navigator.pop(context);
                  onCommentAdded(commentText);
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
