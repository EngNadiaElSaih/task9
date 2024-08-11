import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/provider/post_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController; // استخدام 'late'
  late Animation<double> _animation;
  bool isExpand = false; // تعريف المتغير 'isExpand'

  @override
  void initState() {
    super.initState();

    // تهيئة AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // بدء تشغيل الرسوم المتحركة عند بدء الصفحة
    _animationController.forward();

    final postProvider = Provider.of<PostProvider>(context, listen: false);
    postProvider.fetchPosts();
    postProvider.fetchPost(1);
    postProvider.fetchCommentsForPost(1);
    postProvider.fetchCommentsWithQuery(1);
  }

  @override
  void dispose() {
    // التخلص من AnimationController عند الانتهاء
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('API Demo'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('All Posts:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              for (var p in postProvider.posts)
                Card(child: Text('Post ID: ${p['id']}, Title: ${p['title']}')),
              SizedBox(height: 20),
              Text('Single Post:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              if (postProvider.post.isNotEmpty)
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return AnimatedContainer(
                      height: isExpand ? 250 : 0,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      child: SingleChildScrollView(
                        child: PhysicalModel(
                          clipBehavior: Clip.antiAlias,
                          borderRadius: BorderRadius.circular(15),
                          shadowColor: Colors.black,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Icon(Icons.person),
                              SizedBox(width: 10),
                              Expanded(
                                child: Opacity(
                                  opacity: _animation.value,
                                  child: Text(
                                    'Post ID: ${postProvider.post['id']}, Title: ${postProvider.post['title']}, Body: ${postProvider.post['body']}',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              SizedBox(height: 20),
              Text('Comments for Post ID 1:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              for (var c in postProvider.comments)
                Text(
                    'Comment ID: ${c['id']}, Name: ${c['name']}, Body: ${c['body']}'),
            ],
          ),
        ),
      ),
    );
  }
}
