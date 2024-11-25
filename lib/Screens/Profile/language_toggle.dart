import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nishabdvaani/Provider/language_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageToggle extends ConsumerStatefulWidget{
  const LanguageToggle({super.key});


  @override
  ConsumerState<LanguageToggle> createState() => _LanguageToggleState();
}

class _LanguageToggleState extends ConsumerState<LanguageToggle> {

  bool? firstSwitchValue;

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    return  SizedBox(
        height: 100,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment:  MainAxisAlignment.start,
            children: [
              Icon(Icons.translate, size: 30, color: Colors.blue,),
              const SizedBox(width: 12),
              SizedBox(
                height: 50,
                width: 300,
                child: AnimatedToggleSwitch<bool>.size(
                  current: lang=='en'? false : true,
                  values: [false, true],
                  iconOpacity: 0.2,
                  indicatorSize: const Size.fromWidth(100),
                  customIconBuilder: (context,local,global)=> Text(
                      local.value ? AppLocalizations.of(context)!.gujarati: AppLocalizations.of(context)!.english,
                    style: TextStyle(
                      color: Color.lerp(Colors.black, Colors.white, local.animationValue),
                    ),
                  ),
                  borderWidth: 5.0,
                  iconAnimationType: AnimationType.onHover,
                  style: ToggleStyle(
                    indicatorColor: Colors.blue,
                    borderColor: Colors.white70,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      const BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0,3),
                    )
                  ]
                  ),
                  selectedIconScale: 1.0,
                  onChanged: (value) => setState(() {
                    if(value==true){
                      ref.read(languageProvider.notifier).state = 'gu';
                      firstSwitchValue = true;
                    }
                    else{
                      ref.read(languageProvider.notifier).state = 'en';
                      firstSwitchValue = false;
                    }
                    firstSwitchValue= value;
                  }),
                ),
              )
            ],
          ),
        ),
      );
  }
}