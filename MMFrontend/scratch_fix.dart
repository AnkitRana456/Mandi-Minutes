import 'dart:io';

void main() {
  final dir = Directory('c:\\Backend_Projects\\Mandi-Minutes App\\MMFrontend\\lib');
  
  if (!dir.existsSync()) {
    print('Directory not found');
    return;
  }
  
  var files = dir.listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'));
      
  int count = 0;
  for (var file in files) {
    String content = file.readAsStringSync();
    if (content.contains('\\\$')) {
      // Replace literal \$ with $
      String newContent = content.replaceAll('\\\$', '\$');
      file.writeAsStringSync(newContent);
      print('Fixed \${file.path}');
      count++;
    }
  }
  print('Fixed \$count files.');
}
