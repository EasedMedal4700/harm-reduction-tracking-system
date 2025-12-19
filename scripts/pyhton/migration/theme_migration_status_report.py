import os
import re
import json
import sys

# Define the base directory (assuming the script is in scripts/pyhton/)
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.join(BASE_DIR, '..', '..', '..')
FEATURES_DIR = os.path.join(PROJECT_ROOT, 'lib', 'features')

# Patterns to check for magic numbers (common hardcoded values)
MAGIC_PATTERNS = [
    (r'SizedBox\([^)]*\b\d+\.?\d*\b', 'SizedBox with hardcoded size'),
    (r'elevation:\s*\b\d+\.?\d*\b', 'elevation with hardcoded value'),
    (r'height:\s*\b\d+\.?\d*\b', 'height with hardcoded value'),
    (r'width:\s*\b\d+\.?\d*\b', 'width with hardcoded value'),
    (r'fontSize:\s*\b\d+\.?\d*\b', 'fontSize with hardcoded value'),
    (r'padding:\s*EdgeInsets\([^)]*\b\d+\.?\d*\b', 'padding with hardcoded EdgeInsets'),
    (r'margin:\s*EdgeInsets\([^)]*\b\d+\.?\d*\b', 'margin with hardcoded EdgeInsets'),
    (r'spacing:\s*\b\d+\.?\d*\b', 'spacing with hardcoded value'),
    (r'runSpacing:\s*\b\d+\.?\d*\b', 'runSpacing with hardcoded value'),
    (r'blurRadius:\s*\b\d+\.?\d*\b', 'blurRadius with hardcoded value'),
    (r'spreadRadius:\s*\b\d+\.?\d*\b', 'spreadRadius with hardcoded value'),
    (r'offset:\s*Offset\([^)]*\b\d+\.?\d*\b', 'offset with hardcoded Offset'),
    (r'borderRadius:\s*\b\d+\.?\d*\b', 'borderRadius with hardcoded value'),
    (r'strokeWidth:\s*\b\d+\.?\d*\b', 'strokeWidth with hardcoded value'),
    (r'size:\s*\b\d+\.?\d*\b', 'size with hardcoded value'),
    (r'iconSize:\s*\b\d+\.?\d*\b', 'iconSize with hardcoded value'),
    (r'TextStyle\([^)]*fontSize:\s*\b\d+\.?\d*\b', 'TextStyle with hardcoded fontSize'),
    (r'FontWeight\.w\d+', 'FontWeight with hardcoded value'),
    (r'Color\(0x[0-9a-fA-F]+\)', 'hardcoded Color'),
    (r'Colors\.[a-zA-Z]+', 'hardcoded Colors'),
    (r'BoxShadow\([^)]*\b\d+\.?\d*\b', 'BoxShadow with hardcoded values'),
    (r'CircularProgressIndicator\([^)]*strokeWidth:\s*\b\d+\.?\d*\b', 'CircularProgressIndicator with hardcoded strokeWidth'),
    (r'shadowColor:\s*Color\(', 'hardcoded shadowColor'),
    (r'BorderRadius\([^)]*\b\d+\.?\d*\b', 'BorderRadius with hardcoded values'),
    (r'Icon\([^)]*size:\s*\b\d+\.?\d*\b', 'Icon with hardcoded size'),
    (r'Container\([^)]*height:\s*\b\d+\.?\d*\b', 'Container with hardcoded height'),
    (r'Container\([^)]*width:\s*\b\d+\.?\d*\b', 'Container with hardcoded width'),
    (r'opacity:\s*\b\d+\.?\d*\b', 'opacity with hardcoded value'),
    (r'withOpacity\(\b\d+\.?\d*\b\)', 'withOpacity with hardcoded value'),
    (r'Duration\([^)]*\b\d+\b', 'Duration with hardcoded value'),
    (r'Curve\.[a-zA-Z]+', 'hardcoded Curve'),
    (r'AnimationController\([^)]*duration:\s*Duration\(', 'AnimationController with hardcoded duration'),
    (r'lineHeight:\s*\b\d+\.?\d*\b', 'lineHeight with hardcoded value'),
    (r'letterSpacing:\s*\b\d+\.?\d*\b', 'letterSpacing with hardcoded value'),
    (r'wordSpacing:\s*\b\d+\.?\d*\b', 'wordSpacing with hardcoded value'),
    (r'borderWidth:\s*\b\d+\.?\d*\b', 'borderWidth with hardcoded value'),
    (r'radius:\s*\b\d+\.?\d*\b', 'radius with hardcoded value'),
    (r'scale:\s*\b\d+\.?\d*\b', 'scale with hardcoded value'),
    (r'blurSigma:\s*\b\d+\.?\d*\b', 'blurSigma with hardcoded value'),
    (r'intensity:\s*\b\d+\.?\d*\b', 'intensity with hardcoded value'),
    (r'brightness:\s*\b\d+\.?\d*\b', 'brightness with hardcoded value'),
    (r'contrast:\s*\b\d+\.?\d*\b', 'contrast with hardcoded value'),
    (r'saturation:\s*\b\d+\.?\d*\b', 'saturation with hardcoded value'),
    (r'hue:\s*\b\d+\.?\d*\b', 'hue with hardcoded value'),
    (r'gap:\s*\b\d+\.?\d*\b', 'gap with hardcoded value'),
    (r'maxWidth:\s*\b\d+\.?\d*\b', 'maxWidth with hardcoded value'),
    (r'maxHeight:\s*\b\d+\.?\d*\b', 'maxHeight with hardcoded value'),
    (r'minWidth:\s*\b\d+\.?\d*\b', 'minWidth with hardcoded value'),
    (r'minHeight:\s*\b\d+\.?\d*\b', 'minHeight with hardcoded value'),
    (r'flex:\s*\b\d+\b', 'flex with hardcoded value'),
    (r'crossAxisCount:\s*\b\d+\b', 'crossAxisCount with hardcoded value'),
    (r'mainAxisSpacing:\s*\b\d+\.?\d*\b', 'mainAxisSpacing with hardcoded value'),
    (r'crossAxisSpacing:\s*\b\d+\.?\d*\b', 'crossAxisSpacing with hardcoded value'),
    (r'childAspectRatio:\s*\b\d+\.?\d*\b', 'childAspectRatio with hardcoded value'),
    (r'maxCrossAxisExtent:\s*\b\d+\.?\d*\b', 'maxCrossAxisExtent with hardcoded value'),
    (r'itemExtent:\s*\b\d+\.?\d*\b', 'itemExtent with hardcoded value'),
    (r'viewportFraction:\s*\b\d+\.?\d*\b', 'viewportFraction with hardcoded value'),
    (r'initialPage:\s*\b\d+\b', 'initialPage with hardcoded value'),
    (r'physics:\s*NeverScrollableScrollPhysics\(\)', 'hardcoded ScrollPhysics'),
    (r'physics:\s*AlwaysScrollableScrollPhysics\(\)', 'hardcoded ScrollPhysics'),
    (r'physics:\s*BouncingScrollPhysics\(\)', 'hardcoded ScrollPhysics'),
    (r'physics:\s*ClampingScrollPhysics\(\)', 'hardcoded ScrollPhysics'),
    (r'physics:\s*PageScrollPhysics\(\)', 'hardcoded ScrollPhysics'),
    (r'physics:\s*RangeMaintainingScrollPhysics\(\)', 'hardcoded ScrollPhysics'),
    (r'physics:\s*FixedExtentScrollPhysics\(\)', 'hardcoded ScrollPhysics'),
    (r'clipBehavior:\s*Clip\.[a-zA-Z]+', 'hardcoded ClipBehavior'),
    (r'overflow:\s*TextOverflow\.[a-zA-Z]+', 'hardcoded TextOverflow'),
    (r'textAlign:\s*TextAlign\.[a-zA-Z]+', 'hardcoded TextAlign'),
    (r'verticalDirection:\s*VerticalDirection\.[a-zA-Z]+', 'hardcoded VerticalDirection'),
    (r'mainAxisAlignment:\s*MainAxisAlignment\.[a-zA-Z]+', 'hardcoded MainAxisAlignment'),
    (r'crossAxisAlignment:\s*CrossAxisAlignment\.[a-zA-Z]+', 'hardcoded CrossAxisAlignment'),
    (r'mainAxisSize:\s*MainAxisSize\.[a-zA-Z]+', 'hardcoded MainAxisSize'),
    (r'direction:\s*Axis\.[a-zA-Z]+', 'hardcoded Axis direction'),
    (r'fit:\s*BoxFit\.[a-zA-Z]+', 'hardcoded BoxFit'),
    (r'alignment:\s*Alignment\.[a-zA-Z]+', 'hardcoded Alignment'),
    (r'blendMode:\s*BlendMode\.[a-zA-Z]+', 'hardcoded BlendMode'),
    (r'filterQuality:\s*FilterQuality\.[a-zA-Z]+', 'hardcoded FilterQuality'),
    (r'tileMode:\s*TileMode\.[a-zA-Z]+', 'hardcoded TileMode'),
    (r'gradient:\s*LinearGradient\([^)]*\b\d+\.?\d*\b', 'LinearGradient with hardcoded values'),
    (r'gradient:\s*RadialGradient\([^)]*\b\d+\.?\d*\b', 'RadialGradient with hardcoded values'),
    (r'gradient:\s*SweepGradient\([^)]*\b\d+\.?\d*\b', 'SweepGradient with hardcoded values'),
    (r'shadowOffset:\s*Offset\([^)]*\b\d+\.?\d*\b', 'shadowOffset with hardcoded Offset'),
    (r'shadowBlurRadius:\s*\b\d+\.?\d*\b', 'shadowBlurRadius with hardcoded value'),
    (r'shadowSpreadRadius:\s*\b\d+\.?\d*\b', 'shadowSpreadRadius with hardcoded value'),
    (r'borderSide:\s*BorderSide\([^)]*\b\d+\.?\d*\b', 'BorderSide with hardcoded values'),
    (r'border:\s*Border\([^)]*\b\d+\.?\d*\b', 'Border with hardcoded values'),
    (r'border:\s*Border\.all\([^)]*\b\d+\.?\d*\b', 'Border.all with hardcoded values'),
    (r'outline:\s*OutlinedBorder\([^)]*\b\d+\.?\d*\b', 'OutlinedBorder with hardcoded values'),
    (r'shape:\s*BoxShape\.[a-zA-Z]+', 'hardcoded BoxShape'),
    (r'shape:\s*CircleBorder\(\)', 'hardcoded CircleBorder'),
    (r'shape:\s*RoundedRectangleBorder\([^)]*\b\d+\.?\d*\b', 'RoundedRectangleBorder with hardcoded values'),
    (r'shape:\s*StadiumBorder\(\)', 'hardcoded StadiumBorder'),
    (r'shape:\s*BeveledRectangleBorder\([^)]*\b\d+\.?\d*\b', 'BeveledRectangleBorder with hardcoded values'),
    (r'shape:\s*ContinuousRectangleBorder\([^)]*\b\d+\.?\d*\b', 'ContinuousRectangleBorder with hardcoded values'),
    (r'constraints:\s*BoxConstraints\([^)]*\b\d+\.?\d*\b', 'BoxConstraints with hardcoded values'),
    (r'preferredSize:\s*Size\([^)]*\b\d+\.?\d*\b', 'preferredSize with hardcoded Size'),
    (r'size:\s*Size\([^)]*\b\d+\.?\d*\b', 'Size with hardcoded values'),
    (r'position:\s*Offset\([^)]*\b\d+\.?\d*\b', 'position with hardcoded Offset'),
    (r'transform:\s*Matrix4\([^)]*\b\d+\.?\d*\b', 'Matrix4 with hardcoded values'),
    (r'rotation:\s*\b\d+\.?\d*\b', 'rotation with hardcoded value'),
    (r'scaleX:\s*\b\d+\.?\d*\b', 'scaleX with hardcoded value'),
    (r'scaleY:\s*\b\d+\.?\d*\b', 'scaleY with hardcoded value'),
    (r'translateX:\s*\b\d+\.?\d*\b', 'translateX with hardcoded value'),
    (r'translateY:\s*\b\d+\.?\d*\b', 'translateY with hardcoded value'),
    (r'skewX:\s*\b\d+\.?\d*\b', 'skewX with hardcoded value'),
    (r'skewY:\s*\b\d+\.?\d*\b', 'skewY with hardcoded value'),
    (r'perspective:\s*\b\d+\.?\d*\b', 'perspective with hardcoded value'),
    (r'anchorPoint:\s*Offset\([^)]*\b\d+\.?\d*\b', 'anchorPoint with hardcoded Offset'),
    (r'origin:\s*Offset\([^)]*\b\d+\.?\d*\b', 'origin with hardcoded Offset'),
    (r'pivot:\s*Offset\([^)]*\b\d+\.?\d*\b', 'pivot with hardcoded Offset'),
    (r'center:\s*Offset\([^)]*\b\d+\.?\d*\b', 'center with hardcoded Offset'),
    (r'focalPoint:\s*Offset\([^)]*\b\d+\.?\d*\b', 'focalPoint with hardcoded Offset'),
    (r'focalRadius:\s*\b\d+\.?\d*\b', 'focalRadius with hardcoded value'),
    (r'radius:\s*\b\d+\.?\d*\b', 'radius with hardcoded value'),
    (r'startAngle:\s*\b\d+\.?\d*\b', 'startAngle with hardcoded value'),
    (r'endAngle:\s*\b\d+\.?\d*\b', 'endAngle with hardcoded value'),
    (r'sweepAngle:\s*\b\d+\.?\d*\b', 'sweepAngle with hardcoded value'),
    (r'colors:\s*\[.*Color\(0x[0-9a-fA-F]+\).*]', 'gradient colors with hardcoded Color'),
    (r'stops:\s*\[.*\b\d+\.?\d*\b.*]', 'gradient stops with hardcoded values'),
    (r'tileMode:\s*TileMode\.[a-zA-Z]+', 'hardcoded TileMode'),
    (r'begin:\s*Alignment\.[a-zA-Z]+', 'hardcoded begin Alignment'),
    (r'end:\s*Alignment\.[a-zA-Z]+', 'hardcoded end Alignment'),
    (r'center:\s*Alignment\.[a-zA-Z]+', 'hardcoded center Alignment'),
    (r'radius:\s*\b\d+\.?\d*\b', 'radius with hardcoded value'),
    (r'angle:\s*\b\d+\.?\d*\b', 'angle with hardcoded value'),
    (r'distance:\s*\b\d+\.?\d*\b', 'distance with hardcoded value'),
    (r'elevation:\s*\b\d+\.?\d*\b', 'elevation with hardcoded value'),
    (r'color:\s*Color\(0x[0-9a-fA-F]+\)', 'color with hardcoded Color'),
    (r'backgroundColor:\s*Color\(0x[0-9a-fA-F]+\)', 'backgroundColor with hardcoded Color'),
    (r'foregroundColor:\s*Color\(0x[0-9a-fA-F]+\)', 'foregroundColor with hardcoded Color'),
    (r'surfaceTintColor:\s*Color\(0x[0-9a-fA-F]+\)', 'surfaceTintColor with hardcoded Color'),
    (r'overlayColor:\s*Color\(0x[0-9a-fA-F]+\)', 'overlayColor with hardcoded Color'),
    (r'shadowColor:\s*Color\(0x[0-9a-fA-F]+\)', 'shadowColor with hardcoded Color'),
    (r'borderColor:\s*Color\(0x[0-9a-fA-F]+\)', 'borderColor with hardcoded Color'),
    (r'dividerColor:\s*Color\(0x[0-9a-fA-F]+\)', 'dividerColor with hardcoded Color'),
    (r'primaryColor:\s*Color\(0x[0-9a-fA-F]+\)', 'primaryColor with hardcoded Color'),
    (r'accentColor:\s*Color\(0x[0-9a-fA-F]+\)', 'accentColor with hardcoded Color'),
    (r'canvasColor:\s*Color\(0x[0-9a-fA-F]+\)', 'canvasColor with hardcoded Color'),
    (r'cardColor:\s*Color\(0x[0-9a-fA-F]+\)', 'cardColor with hardcoded Color'),
    (r'dialogBackgroundColor:\s*Color\(0x[0-9a-fA-F]+\)', 'dialogBackgroundColor with hardcoded Color'),
    (r'indicatorColor:\s*Color\(0x[0-9a-fA-F]+\)', 'indicatorColor with hardcoded Color'),
    (r'hintColor:\s*Color\(0x[0-9a-fA-F]+\)', 'hintColor with hardcoded Color'),
    (r'errorColor:\s*Color\(0x[0-9a-fA-F]+\)', 'errorColor with hardcoded Color'),
    (r'toggleableActiveColor:\s*Color\(0x[0-9a-fA-F]+\)', 'toggleableActiveColor with hardcoded Color'),
    (r'disabledColor:\s*Color\(0x[0-9a-fA-F]+\)', 'disabledColor with hardcoded Color'),
    (r'buttonColor:\s*Color\(0x[0-9a-fA-F]+\)', 'buttonColor with hardcoded Color'),
    (r'secondaryHeaderColor:\s*Color\(0x[0-9a-fA-F]+\)', 'secondaryHeaderColor with hardcoded Color'),
    (r'textSelectionColor:\s*Color\(0x[0-9a-fA-F]+\)', 'textSelectionColor with hardcoded Color'),
    (r'cursorColor:\s*Color\(0x[0-9a-fA-F]+\)', 'cursorColor with hardcoded Color'),
    (r'textSelectionHandleColor:\s*Color\(0x[0-9a-fA-F]+\)', 'textSelectionHandleColor with hardcoded Color'),
    (r'backgroundColor:\s*Colors\.[a-zA-Z]+', 'backgroundColor with hardcoded Colors'),
    (r'foregroundColor:\s*Colors\.[a-zA-Z]+', 'foregroundColor with hardcoded Colors'),
    (r'surfaceTintColor:\s*Colors\.[a-zA-Z]+', 'surfaceTintColor with hardcoded Colors'),
    (r'overlayColor:\s*Colors\.[a-zA-Z]+', 'overlayColor with hardcoded Colors'),
    (r'shadowColor:\s*Colors\.[a-zA-Z]+', 'shadowColor with hardcoded Colors'),
    (r'borderColor:\s*Colors\.[a-zA-Z]+', 'borderColor with hardcoded Colors'),
    (r'dividerColor:\s*Colors\.[a-zA-Z]+', 'dividerColor with hardcoded Colors'),
    (r'primaryColor:\s*Colors\.[a-zA-Z]+', 'primaryColor with hardcoded Colors'),
    (r'accentColor:\s*Colors\.[a-zA-Z]+', 'accentColor with hardcoded Colors'),
    (r'canvasColor:\s*Colors\.[a-zA-Z]+', 'canvasColor with hardcoded Colors'),
    (r'cardColor:\s*Colors\.[a-zA-Z]+', 'cardColor with hardcoded Colors'),
    (r'dialogBackgroundColor:\s*Colors\.[a-zA-Z]+', 'dialogBackgroundColor with hardcoded Colors'),
    (r'indicatorColor:\s*Colors\.[a-zA-Z]+', 'indicatorColor with hardcoded Colors'),
    (r'hintColor:\s*Colors\.[a-zA-Z]+', 'hintColor with hardcoded Colors'),
    (r'errorColor:\s*Colors\.[a-zA-Z]+', 'errorColor with hardcoded Colors'),
    (r'toggleableActiveColor:\s*Colors\.[a-zA-Z]+', 'toggleableActiveColor with hardcoded Colors'),
    (r'disabledColor:\s*Colors\.[a-zA-Z]+', 'disabledColor with hardcoded Colors'),
    (r'buttonColor:\s*Colors\.[a-zA-Z]+', 'buttonColor with hardcoded Colors'),
    (r'secondaryHeaderColor:\s*Colors\.[a-zA-Z]+', 'secondaryHeaderColor with hardcoded Colors'),
    (r'textSelectionColor:\s*Colors\.[a-zA-Z]+', 'textSelectionColor with hardcoded Colors'),
    (r'cursorColor:\s*Colors\.[a-zA-Z]+', 'cursorColor with hardcoded Colors'),
    (r'textSelectionHandleColor:\s*Colors\.[a-zA-Z]+', 'textSelectionHandleColor with hardcoded Colors'),
]

def find_magic_numbers(file_path):
    issues = []
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
            for line_num, line in enumerate(lines, 1):
                for pattern, description in MAGIC_PATTERNS:
                    if re.search(pattern, line):
                        issues.append({
                            'line': line_num,
                            'description': description,
                            'snippet': line.strip()
                        })
    except Exception as e:
        issues.append({'error': str(e)})
    return issues

def scan_features():
    report = {}
    for root, dirs, files in os.walk(FEATURES_DIR):
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(root, file)
                relative_path = os.path.relpath(file_path, PROJECT_ROOT)
                issues = find_magic_numbers(file_path)
                migrated = len(issues) == 0
                if not migrated:
                    report[relative_path] = {
                        'migrated': migrated,
                        'issues': issues
                    }
    return report

def main():
    report = scan_features()
    output_file = os.path.join(BASE_DIR, 'theme_migration_report.json')
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(report, f, indent=2)
    print(f"Report generated: {output_file}")

if __name__ == '__main__':
    main()