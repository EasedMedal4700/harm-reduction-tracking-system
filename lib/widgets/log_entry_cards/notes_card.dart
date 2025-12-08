import 'package:flutter/material.dart';
import '../../common/cards/common_card.dart';
import '../../common/text/common_section_header.dart';
import '../../common/layout/common_spacer.dart';
import '../../common/inputs/common_textarea.dart';
import '../../constants/deprecated/theme_constants.dart';

class NotesCard extends StatelessWidget {
  final TextEditingController notesCtrl;

  const NotesCard({
    super.key,
    required this.notesCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonSectionHeader(
            title: "Additional Notes",
            subtitle: "Any other details worth recording",
          ),

          const CommonSpacer.vertical(ThemeConstants.space12),

          CommonTextarea(
            controller: notesCtrl,
            hintText: "Enter any additional notes...",
            maxLines: 5,
          ),
        ],
      ),
    );
  }
}
