import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:savia/blocs/contact/contact_bloc.dart';
import 'package:savia/constant/size_constant.dart';
import 'package:savia/constant/switch_screen_constant.dart';
import 'package:savia/constant/text_style_constant.dart';
import 'package:savia/lay_out/responsive_layout.dart';
import 'package:savia/models/chat_user.dart';
import 'package:savia/repositories/contact_repo.dart';
import 'package:savia/view/message/message_page.dart';
import 'package:savia/widget/build_loading_circle.dart';
import 'package:savia/widget/custom_chat_card.dart';
import 'package:savia/widget/custom_text_form_field.dart';

class ContactPage extends StatefulWidget {
  final ChatUserModel currentUser;
  const ContactPage({super.key, required this.currentUser});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _searchController = TextEditingController();
  List<ChatUserModel> _listContactUser = [];
  bool _isSearch = false;
  List<ChatUserModel> _searchListContactUser = [];
  final String _notiWhenNoChatuser =
      'Let us take care of your relationships 😘';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
        body: BlocListener<ContactBloc, ContactState>(
      listener: (context, state) {},
      child: BlocBuilder<ContactBloc, ContactState>(
        builder: (context, state) {
          if (state is ContactLoading) {
            return const Center(
                child: BuildLoadingCircle(
              height: 80,
              width: 80,
            ));
          } else if (state is ContactLoadChatUserSuccessed) {
            _listContactUser = state.listContactUser;
            return (_listContactUser.isEmpty)
                ? Center(
                    child: Text(_notiWhenNoChatuser,
                        textAlign: TextAlign.center, maxLines: 2))
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          child: _searchBar()),
                      context.sizedBox(
                          height:
                              SizeConstant.textFormFileWithTextFormFiled / 2),
                      AnimationLimiter(
                        child: ListView.builder(
                            shrinkWrap: true,
                            reverse: true,
                            itemCount: _isSearch
                                ? _searchListContactUser.length
                                : _listContactUser.length,
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            itemBuilder: (context, index) {
                              return AnimationConfiguration.staggeredList(
                                  position: index,
                                  delay: const Duration(milliseconds: 100),
                                  child: SlideAnimation(
                                      duration:
                                          const Duration(milliseconds: 2500),
                                      curve: Curves.fastLinearToSlowEaseIn,
                                      child: CustomChatCard(
                                          onPressed: (context) {
                                            _deleteContactUser(
                                                id: _listContactUser[index].id);
                                          },
                                          isChatPage: false,
                                          currentUser: widget.currentUser,
                                          guestUser: _isSearch
                                              ? _searchListContactUser[index]
                                              : _listContactUser[index],
                                          subTitle: _showId(index),
                                          trailing: IconButton(
                                            onPressed: () {
                                              _addChatUser(
                                                  checkId:
                                                      _listContactUser[index]
                                                          .checkId);
                                              SwitchScreenConstant.nextScreen(
                                                  context,
                                                  MessagePage(
                                                      currentUser:
                                                          widget.currentUser,
                                                      guestUser: _isSearch
                                                          ? _searchListContactUser[
                                                              index]
                                                          : _listContactUser[
                                                              index]));
                                            },
                                            icon: const Icon(
                                                Icons.chat_outlined,
                                                size: 30),
                                          ))));
                            }),
                      ),
                    ]),
                  );
          }
          return Center(
              child: Text(_notiWhenNoChatuser,
                  style: TextStyleConstant.dontHavaAccount));
        },
      ),
    ));
  }

  Future<void> _addChatUser({required String checkId}) async {
    context
        .read<ContactBloc>()
        .add(ContactAddContactUserEvent(checkId: checkId));
  }

  Widget _searchBar() {
    return CustomTextFormField(
      prefixIcon: const Icon(Icons.search_outlined),
      controller: _searchController,
      keyboardType: TextInputType.text,
      hintText: 'Search by ID',
      onChanged: (value) {
        _isSearch = (value.isEmpty) ? false : true;
        _searchListContactUser.clear();

        for (var user in _listContactUser) {
          if (user.name.toLowerCase().contains(value.toLowerCase()) ||
              user.checkId.toLowerCase().contains(value.toLowerCase())) {
            _searchListContactUser.add(user);
            setState(() {
              _searchListContactUser;
              _isSearch;
            });
          } else {
            setState(() {
              _searchListContactUser = [];
              _isSearch;
            });
          }
        }
      },
    );
  }

  Future<void> _deleteContactUser({required String id}) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.topSlide,
      headerAnimationLoop: true,
      body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('Click Delete to remove this contact!')),
      btnOkIcon: Icons.cancel,
      btnOkColor: Colors.blue,
      //btnCancel: const Icon(Icons.cancel),
      btnOkText: 'Cencel',
      btnCancelText: 'Delete',
      btnCancelColor: Colors.red,
      btnCancelIcon: Icons.check,
      btnOkOnPress: () {},
      btnCancelOnPress: () async {
        context.read<ContactBloc>().add(ContactDeleteContactUserEvent(id: id));
      },
    ).show();
  }

  Widget _showId(int index) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SelectableText(
            'ID: ${_isSearch ? _searchListContactUser[index].checkId : _listContactUser[index].checkId}',
            style: const TextStyle(fontSize: 12),
          ),
          context.sizedBox(width: 10),
          InkWell(
              onTap: () async {
                await Clipboard.setData(ClipboardData(
                        text: _isSearch
                            ? _searchListContactUser[index].checkId
                            : _listContactUser[index].checkId))
                    .then((value) => ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
                            backgroundColor: Colors.black54,
                            content: Center(
                                child: Text(
                              'ID copied',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            )))));
              },
              child: const Icon(Icons.copy, size: 20))
        ]);
  }
}
