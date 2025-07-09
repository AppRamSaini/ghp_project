import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// DELETE CHAT DIALOG
void deleteChatDialog(BuildContext context, chatId) => showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_ctx) {
        return Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Are you sure you want to delete this chat!',
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text('CANCEL',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w500))),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        FirebaseFirestore.instance
                            .collection('groups')
                            .doc(chatId)
                            .delete();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'YES, DELETE',
                        style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
