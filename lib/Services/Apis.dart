import 'package:soloconneckt/Services/constants.dart';

class ApiUrl {
  static String login = "/User/Login.php";
  static String register = "/User/RegisterUser.php";
  static String editUser = "/User/editUser.php";
  static String getUser(user_id) => "/User/GetUserProfile.php?user_id=$user_id&auth_key=$auth_key";
  static String getPost = "/Post/GetPost.php?auth_key=$auth_key&byid=false";
  static String getPostById(userid,byid) => "/Post/GetPost.php?auth_key=$auth_key&byid=$byid&user_id=$userid";
  static String getSavedPost(userid) => "/Post/SavedPost/GetSavedPost.php?auth_key=$auth_key&user_id=$userid";
  static String createLikedPost(userid) => "/Post/LikedPost/CreateLikedPost.php?auth_key=$auth_key&user_id=$userid";
  static String getChat = "/Chat/getGroupChat.php?auth_key=$auth_key";
  static String getDirectChat(userid) => "/Chat/GetDirectMessagesChat.php?auth_key=$auth_key&user_id=$userid";
  static String createPost = "/Post/CreatePost.php";
  static String deleteSavedPost(user_id,post_id) => "/Post/SavedPost/deletePost.php?auth_key=$auth_key&user_id=$user_id&post_id=$post_id";
  static String deleteGroupChat(user_id) => "/Chat/deleteGroup.php?auth_key=$auth_key&user_id=$user_id";
  static String deletePost(user_id,post_id) => "/Post/deletePost.php?auth_key=$auth_key&user_id=$user_id&post_id=$post_id";
  static String deleteLikedPost(user_id,post_id) => "/Post/LikedPost/deleteLikedPost.php?auth_key=$auth_key&user_id=$user_id&post_id=$post_id";
  static String reportPost(post_id) => "/Post/reportPost.php?auth_key=$auth_key&post_id=$post_id";
  static String createSavedPost = "/Post/SavedPost/CreateSavedPost.php";
  static String createChatGroup = "/Chat/CreateGroupChat.php";
  static String getUserProfile = "/User/GetUserProfile.php?auth_key=$auth_key";
  static String getMessages(groupid) => "/Chat/getMessages.php?auth_key=$auth_key&groupid=$groupid";
  static String getDirectMessages(receiver_id,sender_id) => "/Chat/GetDirectMessages.php?auth_key=$auth_key&sender_id=$sender_id&receiver_id=$receiver_id";
  static String SendMessages= "/Chat/SendMessage.php";
  static String SendDirectMessages= "/Chat/SendDirectMessage.php";
   static String deleteStory(user_id,story_id) => "/Stories/deleteStory.php?auth_key=$auth_key&user_id=$user_id&story_id=$story_id";
    static String getStory = "/Stories/GetStory.php?auth_key=$auth_key";
     static String createStory = "/Stories/CreateStory.php";
      static String getStoryByID(userid,byid) => "/Stories/GetStory.php?auth_key=$auth_key&byid=$byid&user_id=$userid";
}
