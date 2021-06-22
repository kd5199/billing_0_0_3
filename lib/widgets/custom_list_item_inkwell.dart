import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_slidable/flutter_slidable.dart';

class CustomListItemWithInkWell extends StatefulWidget {
  //const CustomListItemWithInkWell({ Key? key }) : super(key: key);
  final File imageUrl;
  final Function deleteFunction;
  final Function editFunction;
  final String id;
  final String title;
  final String subtitle1;
  final String subtitle2;
  final String subtitle3;
  final String subtitle4;
  final String trailing1;
  final String trailing2;
  final String trailing3;
  final Widget trailingWidget1;
  final Widget bottom1;
  final Widget bottom2;
  final Color bottomColor;
  bool selected;

  CustomListItemWithInkWell(
      {this.imageUrl,
      this.selected = false,
      this.deleteFunction,
      this.editFunction,
      this.id,
      this.subtitle1,
      this.subtitle2,
      this.subtitle3,
      this.subtitle4,
      this.title,
      this.trailing1,
      this.trailing2,
      this.trailing3,
      this.trailingWidget1,
      this.bottom1,
      this.bottomColor,
      this.bottom2});
  @override
  _CustomListItemWithInkWellState createState() =>
      _CustomListItemWithInkWellState();
}

class _CustomListItemWithInkWellState extends State<CustomListItemWithInkWell> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actions: [
        if (widget.deleteFunction != null)
          IconSlideAction(
            closeOnTap: true,
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              return showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  content: Text('You really want to delete the item?'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: Text('Are you sure?'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          widget.deleteFunction();
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'))
                  ],
                ),
              );
            },
          )
      ],
      secondaryActions: [
        if (widget.editFunction != null)
          IconSlideAction(
            closeOnTap: true,
            caption: 'Edit',
            color: Colors.green,
            icon: Icons.edit,
            onTap: () {
              widget.editFunction();
            },
          )
      ],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  widget.selected = !widget.selected;
                });
              },
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: (widget.imageUrl != null &&
                                  widget.imageUrl.path.length > 0)
                              ? Image.file(
                                  widget.imageUrl,
                                  height: deviceSize.width / 6,
                                  width: deviceSize.width / 6,
                                  fit: BoxFit.fill,
                                )
                              : Container(
                                  alignment: Alignment.center,
                                  height: deviceSize.width / 6,
                                  width: deviceSize.width / 6,
                                  color: Colors.blue,
                                  child: Text(
                                    '${widget.title[0]}',
                                    textAlign: TextAlign.center,
                                  ),
                                ))),
                  Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              widget.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                              overflow: TextOverflow.fade,
                            ),
                            Text(
                              widget.subtitle1,
                              style: TextStyle(color: Colors.grey),
                              overflow: TextOverflow.fade,
                            ),
                            if (widget.subtitle2 != null)
                              Text(
                                widget.subtitle2,
                                style: TextStyle(color: Colors.grey),
                                overflow: TextOverflow.fade,
                              ),
                            if (widget.subtitle3 != null)
                              Text(
                                widget.subtitle3,
                                style: TextStyle(color: Colors.grey),
                                overflow: TextOverflow.fade,
                              ),
                            if (widget.subtitle4 != null)
                              Text(
                                widget.subtitle4,
                                style: TextStyle(color: Colors.grey),
                                overflow: TextOverflow.fade,
                              )
                          ],
                        ),
                      )),
                  Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            if (widget.trailing1 != null)
                              Text(
                                widget.trailing1,
                                overflow: TextOverflow.fade,
                              ),
                            if (widget.trailing2 != null)
                              Text(
                                widget.trailing2,
                                //style: TextStyle(color: Colors.grey),
                                overflow: TextOverflow.fade,
                              ),
                            if (widget.trailing3 != null)
                              Text(
                                widget.trailing3,
                                //style: TextStyle(color: Colors.grey),
                                overflow: TextOverflow.fade,
                              ),
                            if (widget.trailingWidget1 != null)
                              widget.trailingWidget1,
                          ],
                        ),
                      )),
                ],
              ),
            ),
            if (widget.bottom1 != null)
              Divider(
                color: Colors.amber,
                height: 5,
              ),
            if (widget.bottom1 != null) widget.bottom1,
            if (widget.bottom2 != null)
              Divider(
                color: Colors.black,
              ),
            if (widget.selected)
              if (widget.bottom2 != null) widget.bottom2,
            if (widget.selected)
              widget.bottomColor == null
                  ? Divider()
                  : Divider(
                      color: widget.bottomColor,
                    )
          ],
        ),
      ),
    );
  }
}
