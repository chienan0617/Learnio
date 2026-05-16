import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_math_fork/flutter_math.dart' as tex;
import 'package:markdown/markdown.dart' as md;
import 'package:learnio/base.dart';

const String _latexPattern = r'(\$\$[\s\S]+?\$\$)|(\$[^\$]+?\$)';

class MarkdownLatexSyntax extends md.InlineSyntax {
  MarkdownLatexSyntax() : super(_latexPattern);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final String content = match.group(0)!;
    final bool isDisplayMode = content.startsWith('\$\$');
    final String formula = isDisplayMode
        ? content.substring(2, content.length - 2)
        : content.substring(1, content.length - 1);

    final md.Element element = md.Element.text('latex', formula);
    element.attributes['displayMode'] = isDisplayMode.toString();
    parser.addNode(element);
    return true;
  }
}

class CodeElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    var language = '';

    if (element.attributes['class'] != null) {
      String lg = element.attributes['class'] as String;
      if (lg.startsWith('language-')) {
        language = lg.substring(9);
      }
    }

    final code = element.textContent.trim();

    // Check if it's a single line code or a block
    final isInline = !element.textContent.contains('\n') && language.isEmpty;

    if (isInline) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: bg3.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          code,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: (preferredStyle?.fontSize ?? 14) * 0.9,
            color: CommonColors.warning,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xff282c34),
        borderRadius: BorderRadius.circular(8),
      ),
      child: HighlightView(
        code,
        language: language,
        theme: atomOneDarkTheme,
        padding: const EdgeInsets.all(12),
        textStyle: const TextStyle(fontFamily: 'monospace', fontSize: 14),
      ),
    );
  }
}

class LatexElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final String formula = element.textContent;
    final bool isDisplayMode = element.attributes['displayMode'] == 'true';

    return tex.Math.tex(
      formula,
      mathStyle: isDisplayMode ? tex.MathStyle.display : tex.MathStyle.text,
      textStyle: preferredStyle?.copyWith(
        fontSize: isDisplayMode ? 16 : (preferredStyle.fontSize ?? 14),
      ),
      onErrorFallback: (err) =>
          Text(formula, style: const TextStyle(color: Colors.red)),
    );
  }
}
