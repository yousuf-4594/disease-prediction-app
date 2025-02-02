import 'package:flutter/material.dart';
import 'package:plants/service/language.dart';

class Tomato extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Languages.translate('STEPS TO GROW A TOMATO')!,
          style: TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.white60,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: SingleChildScrollView(
        // To allow scrolling if content is long
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30),
            if (Languages.language == 'en') ...{
              Text(
                '1. Choose the Right Variety: Select a tomato variety that suits your climate and space.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                '2. Start Seeds Indoors: Plant tomato seeds indoors 6-8 weeks before the last frost date.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                '3. Transplant Seedlings: Once the danger of frost has passed, transplant the seedlings outdoors.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                '4. Provide Adequate Sunlight: Ensure your tomato plants receive at least 6-8 hours of sunlight daily.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                '5. Water Regularly: Keep the soil consistently moist but not waterlogged.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                '6. Fertilize Appropriately: Use a balanced fertilizer to nourish your plants.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                '7. Support Plants: Use stakes or cages to support the growing plants and prevent bending.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                '8. Prune and Train: Prune excess leaves and train the plant to encourage healthy growth.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                '9. Monitor for Pests and Diseases: Regularly check for signs of pests or diseases and take appropriate measures.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                '10. Harvest: Pick tomatoes when they are firm and fully colored for the best flavor.',
                style: TextStyle(fontSize: 18),
              ),
            } else ...{
              Text(
                '1. اختر الصنف المناسب: اختر نوعاً من الطماطم يناسب مناخك ومساحتك.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                '2. بدء البذور داخل المنزل: زرع بذور الطماطم في الداخل قبل 6-8 أسابيع من تاريخ آخر استجمام للصقيع.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                '3. نقل الشتلات: بمجرد انتهاء خطر الصقيع، قم بنقل الشتلات إلى الهواء الطلق.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                '4. توفير أشعة الشمس الكافية: تأكد من أن نباتات الطماطم تتلقى 6-8 ساعات من أشعة الشمس يومياً.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                '5. ري بانتظام: احرص على أن يكون التربة رطبة باستمرار ولكن ليس مشبعاً بالماء.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                '6. التسميد بشكل مناسب: استخدم سمادًا متوازنًا لتغذية نباتاتك.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                '7. دعم النباتات: استخدم أعواد أو أقفاصًا لدعم نمو النباتات ومنع الانحناء.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                '8. التقليم والتدريب: اقلم الأوراق الزائدة وقم بتدريب النبات لتعزيز النمو الصحي.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                '9. رصد الآفات والأمراض: قم بفحص النباتات بانتظام للبحث عن علامات الآفات أو الأمراض واتخذ التدابير المناسبة.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                '10. الحصاد: اقطف الطماطم عندما تكون صلبة وملونة تماماً للحصول على أفضل نكهة.',
                style: TextStyle(fontSize: 18),
              ),
            }
          ],
        ),
      ),
    );
  }
}
