import 'package:familytree/core/providers/api.dart';
import 'package:http/http.dart' as http;

class SmsProvider implements OneWaySmsAPI {
  String _apiUsername = 'APIBYBNL6523N';
  String _apiPassword = 'APIBYBNL6523NONI2T';
  String _senderID = 'wareih';
  String _languageType = '1';
  String _messagePrefix = 'RM0.00 Wareih: ';
  String _endPoint = 'http://gateway.onewaysms.com.my:10001';
  
  @override
  Future<bool> sendSms(String numbers, String message) async {
    return await http.get('$_endPoint/api.aspx?apiusername=$_apiUsername&apipassword=$_apiPassword&mobileno=$numbers&senderid=$_senderID&languagetype=$_languageType&message=$_messagePrefix$message').then((response) {
      if (response.statusCode == 200) {
        var result = int.tryParse(response.body) ?? 0;
        if (result > 0) {
          return true;          
        } else {
          return false;
        }
      } else {
        return false;
      }
    }).catchError((error) {
      throw error;
    });
  }
}
