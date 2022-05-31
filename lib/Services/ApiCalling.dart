import 'package:soloconneckt/Services/ApiClient.dart';

import 'Apis.dart';

class ApiCall {
  HttpService _httpService = HttpService();
  LoginUser(user_email, user_passowrd, context) {
    _httpService.Login(user_email, user_passowrd, context, ApiUrl.login);
  }

  RegisterUser(name,email,number,password,imageFile,interest,  context ) {
    _httpService.register(name,email,number,password,imageFile, interest, context, ApiUrl.register,false,"");
  }
  EditUser(id,name,email,number,password,imageFile,interest,  context,) {
    _httpService.register(name,email,number,password,imageFile,interest,  context, ApiUrl.editUser,true,id);
  }
  CreatePost(userid,datetime,Caption,imageFile,  context ) {
    _httpService.NewPost(userid,datetime,Caption,imageFile,  context,ApiUrl.createPost);
  }
   CreateStory(userid,datetime,Caption,imageFile,  context ) {
    _httpService.NewStory(userid,datetime,Caption,imageFile,  context,ApiUrl.createStory);
  }
  CreateTopic(userid,datetime,name,imageFile,  context ) {
    _httpService.NewTopic(userid,datetime,name,imageFile,  context,ApiUrl.createChatGroup);
  }
  SavedPost(userid,postid,  context ) {
    _httpService.SavedPost(userid,postid,context,ApiUrl.createSavedPost);
  }
   DeletePost(user_id,post_id,  context ) {
    _httpService.deleteSavedPost(user_id,post_id,context,ApiUrl.deleteSavedPost(user_id, post_id,));
  }
   DeleteGroupChat(user_id,  context ) {
    _httpService.deleteGroupChat(user_id,context,ApiUrl.deleteGroupChat(user_id));
  }
  LikedPost(userid,postid,  context ) {
    _httpService.LikedPost(userid,postid,context,ApiUrl.createLikedPost(userid));
  }
   DeleteLikedPost(user_id,post_id,  context ) {
    _httpService.deleteLikedPost(user_id,post_id,context,ApiUrl.deleteLikedPost(user_id, post_id,));
  }
   ReportPost(post_id,  context ) {
    _httpService.reportPost(context,ApiUrl.reportPost( post_id));
  }
  DeleteUserPost(user_id,post_id,  context ) {
    _httpService.deletePost(context,ApiUrl.deletePost(user_id, post_id,));
  }
  DeleteStory(user_id, story_id,context ) {
    _httpService.deletePost(context,ApiUrl.deleteStory(user_id, story_id,));
  }
  
}
