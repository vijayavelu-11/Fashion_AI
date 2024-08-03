import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';



class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;
  final String textt = "analyze my image for face shape, skin color, skin tone, hairstyle, hair type, hair color, body shape, body size and fitness to suggest me best hairstyles, best colors to wear, best suited accessories, best suited dressing style, suitable glass frames and etc... with detailed explainations and proper structure";

  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  // Add your API key here
  final String apiKey = 'your_api_key';

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _generateContent() async {
    if (apiKey.isEmpty) {
      print('API key is required.');
      return;
    }

    if (_image == null || textt.isEmpty) {
      print('Image and text prompt are required.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
      final imageBytes = await _image!.readAsBytes();
      final prompt = TextPart(textt);
      final imagePart = DataPart('image/jpeg', imageBytes);

      final response = await model.generateContent([
        Content.multi([prompt, imagePart])
      ]);

      if (response.text != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResponseScreen(response: response.text!),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        
        title: Text('FASHION  AI', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      
      body:

      
       Padding(
        
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 25,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                
                child: Row(
                  children: [
                    Container(
                      height: 70,
                      width: 400,
                      decoration: BoxDecoration(border: Border.all(color: Colors.black),borderRadius: BorderRadius.circular(15)),
                    child:  Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text("Enhance your style effortlessly with Dress Suggestion AI – your personal fashion consultant for every occasion.",style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    ),
                    
                  ],
                ),
              ),
            ),const SizedBox(height: 60,),
            if (_image != null)
              Container(
                width: 200,
                height: 380,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                
                child: Image.file(
                  
                  _image!,
                  fit: BoxFit.cover,
                  height: 400,
                  width: 200,
                ),
              ),
                
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                
                children: [    
                        const SizedBox(height: 20,),      
                  IconButton(
             splashColor: Colors.yellow,
              icon: Icon(Icons.camera_alt_outlined),
              color: Colors.black,
              iconSize: 30,
              onPressed: _getImage,
              
            ),
              
                Text("UPLOAD A PHOTO",style: TextStyle(fontWeight: FontWeight.bold),)  
                ], 
              ),
              
            ),
            if (_isLoading) CircularProgressIndicator(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          tooltip: 'Increment',
          onPressed: _generateContent,
          child: const Icon(Icons.arrow_forward, color: Colors.white),
          ),
    );
  }
}

class ResponseScreen extends StatelessWidget {
  final String response;

  const ResponseScreen({Key? key, required this.response}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SUGGESTIONS',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            response,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              overflow: TextOverflow.clip,
            ),
          ),
        ),
      ),
    );
  }
}
