import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savia/blocs/dashboard/dashboard_bloc.dart';
import 'package:savia/blocs/sign_out/sign_out_bloc.dart';
import 'package:savia/constant/image_constant.dart';
import 'package:savia/constant/size_constant.dart';
import 'package:savia/constant/switch_screen_constant.dart';
import 'package:savia/constant/text_style_constant.dart';
import 'package:savia/lay_out/responsive_layout.dart';
import 'package:savia/models/chat_user.dart';
import 'package:savia/repositories/sign_out_repository.dart';
import 'package:savia/view/auth/sign_in/sign_in.dart';
import 'package:savia/view/profile/build_widgets/build_id_user.dart';
import 'package:savia/view/profile_editting/profile_editting_page.dart';

class ProfilePage extends StatefulWidget {
  final ChatUserModel currentUser;
  const ProfilePage({super.key, required this.currentUser});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _imagePathCurrentUser;
  String showId = '';
  String? idUser;
  @override
  void initState() {
    super.initState();
    _imagePathCurrentUser = widget.currentUser.image;
    showId = widget.currentUser.checkId;
    idUser = FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: BlocProvider(
      create: (context) => SignOutBloc(signOutRepository: SignOutRepository()),
      child: BlocListener<SignOutBloc, SignOutState>(
          listener: (context, state) {
        if (state is SignedOut) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => SignInPage()),
            (route) => false,
          );
        }
        if (state is SignOutError) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => SignInPage()),
            (route) => false,
          );
        }
      }, child:
              BlocBuilder<SignOutBloc, SignOutState>(builder: (context, state) {
        if (state is UnSignedOut) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                children: [
                  Row(children: [
                    (idUser != widget.currentUser.id)
                        ? IconButton(
                            onPressed: () {
                              // SwitchScreenConstant.nextScreen(
                              //     context, const DashBoard());
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back_ios, size: 30))
                        : Container()
                  ]),
                  Column(children: [
                    context.sizedBox(
                        height: context.sizeWidth(150) -
                            SizeConstant.heightOfAppBar),
                    Container(
                      height: context.sizeHeight(500),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            spreadRadius: 5,
                            blurRadius: 15,
                            offset: const Offset(
                                0, 4), // changes position of shadow
                          ),
                        ],
                        color: Colors.blue,
                      ),
                    ),
                  ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _showAvatar(size),
                        context.sizedBox(
                            height: context.sizeHeight(
                                SizeConstant.textFormFileWithTextFormFiled *
                                    2)),
                        // id of user
                        BuildIdUser(
                          showId: showId,
                        ),
                        context.sizedBox(
                            height:
                                SizeConstant.textFormFileWithTextFormFiled / 2),
                        // name of user
                        Text(widget.currentUser.name,
                            textAlign: TextAlign.center,
                            style: TextStyleConstant.nameOfProfile),
                        context.sizedBox(
                            height: SizeConstant.textFormFileWithTextFormFiled),
                        // about of user
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  SizeConstant.horizontalOfTextFormFieldSignIn),
                          child: Text(widget.currentUser.about,
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              style: TextStyleConstant.textOfTextFormField),
                        ),
                        context.sizedBox(
                            height:
                                SizeConstant.textFormFileWithTextFormFiled * 5),

                        // check the uid - id of profile need to show
                      ]),
                  if (idUser == widget.currentUser.id) ...{
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          children: [
                            context.sizedBox(
                                height: context.sizeWidth(150) -
                                    SizeConstant.heightOfAppBar),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    onPressed: () =>
                                        SwitchScreenConstant.nextScreen(
                                            context,
                                            ProfileEdittingPage(
                                                currentUser:
                                                    widget.currentUser)),
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 30,
                                    )),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    onPressed: () => _signOut(context: context),
                                    icon: const Icon(
                                      Icons.logout_outlined,
                                      size: 30,
                                    )),
                              ],
                            )
                          ],
                        ))
                  }
                ],
              ),
            ),
          );
        }
        return Container();
      })),
    ));
  }

  void _signOut({required BuildContext context}) {
    // when sign out => update status of user is offline
    context
        .read<DashboardBloc>()
        .add(const DashboardUpdateUserStatusEvent(status: false));
    context.read<SignOutBloc>().add(SignOutAccountEvent());
  }

  Widget _showAvatar(Size size) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Center(
        child: Container(
          width: context.sizeWidth(150),
          height: context.sizeWidth(150),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                spreadRadius: 3,
                blurRadius: 10,
                offset: const Offset(0, 4), // changes position of shadow
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size.height * .5),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: _imagePathCurrentUser!,
              errorWidget: (context, url, error) => CircleAvatar(
                  child: Image(image: AssetImage(ImageConstant.cameraIcon))),
            ),
          ),
        ),
      ),
    );
  }
}
