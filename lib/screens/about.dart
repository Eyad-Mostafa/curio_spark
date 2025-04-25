import 'package:flutter/material.dart';
import 'package:curio_spark/constants/colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Icon(Icons.auto_awesome, size: 50, color: Theme.of(context).iconTheme.color),
                  const SizedBox(height: 10),
                  Text(
                    "About Us",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            Text(
              """CurioSpark is an app designed by students from the Faculty of Science, Ain Shams University, as part of our project and collaboration with Gemini (AI).

It refers to: Interesting facts, fascinating ideas, rare or unusual knowledge, things that spark wonder or attention.

💡 What does “CurioSpark” mean?
• Curio = short for “Curiosity”  
• Spark = to ignite something (like an idea, thought, or feeling)

So CurioSpark means:
“A spark of curiosity” — an app that lights up your curiosity with a daily dose of wonder.""",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 16,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 30),
            const Divider(thickness: 1.2),

            const SizedBox(height: 20),
            Text(
              "Meet the Team",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),

            MemberCard(
              name: "Abdulrahman Hamdy",
              email: AbdulrahmanEmail,
              imagePath: AbdulrahmanImg,
            ),
            MemberCard(
              name: "Eyad Mostafa",
              email: EyadEmail,
              imagePath: EyadImg,
            ),
            MemberCard(
              name: "Rahma Nasser",
              email: RahmaEmail,
              imagePath: RahmaImg,
            ),
            MemberCard(
              name: "Rashad Mostafa",
              email: RashadEmail,
              imagePath: RashadImg,
            ),
          ],
        ),
      ),
    );
  }
}

class MemberCard extends StatelessWidget {
  final String name;
  final String email;
  final String imagePath;

  const MemberCard({
    super.key,
    required this.name,
    required this.email,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: 6,  
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(imagePath),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style:TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
