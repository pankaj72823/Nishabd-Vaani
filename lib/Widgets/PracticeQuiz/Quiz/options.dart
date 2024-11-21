import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Options extends StatefulWidget{
  const Options({super.key, required this.option});

  final String option;
  @override
  State<Options> createState() {
    return _Options();

  }

}

class _Options extends State<Options>{
  int? _selectedValue;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          InkWell(
            onTap: (){
              setState(() {
                _selectedValue = 1;
              });
            },
            child: Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
              border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: ListTile(
                  title: Align(
                    alignment: Alignment.center,
                    child: Text(widget.option,
                      style: GoogleFonts.openSans(
                      fontSize: 20,
                    ),
                    ),
                  ),
                            ),
              ),
          ),
          ),
          const SizedBox(height: 8,),
        ],
      ),

    );
  }

}