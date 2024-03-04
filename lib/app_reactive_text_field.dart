import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AppReactiveTextField<T> extends StatefulWidget {
  const AppReactiveTextField({
    super.key,
    required this.formControl,
    this.validationMessages,
    this.helperText,
    this.hintText,
    this.label,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
  });

  final FormControl<T> formControl;
  final Map<String, ValidationMessageFunction>? validationMessages;
  final String? helperText, hintText, label;
  final Widget? suffixIcon, prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  State<AppReactiveTextField<T>> createState() =>
      _AppReactiveTextFieldState<T>();
}

class _AppReactiveTextFieldState<T> extends State<AppReactiveTextField<T>> {
  late bool _obscureText;

  @override
  void initState() {
    _obscureText = widget.obscureText;
    super.initState();
  }

  BoxConstraints get _iconConstraints => const BoxConstraints(
        minWidth: 20,
        minHeight: 20,
      );

  Widget _getSuffixIcon(AbstractControl formControl) {
    final isError = formControl.invalid && formControl.touched;
    if (widget.obscureText) {
      return _IconContainer.suffix(
        onTap: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        color: isError ? Theme.of(context).colorScheme.error : null,
        child: _obscureText
            ? const Icon(Icons.visibility_off)
            : const Icon(Icons.visibility),
      );
    }
    if (isError) {
      return _IconContainer.suffix(
        color: Theme.of(context).colorScheme.error,
        child: const Icon(Icons.error),
      );
    }
    if (widget.suffixIcon != null) {
      return _IconContainer.suffix(
        child: widget.suffixIcon!,
      );
    }
    return const SizedBox.shrink();
  }

  Widget get _prefixIcon {
    if (widget.prefixIcon != null) {
      return _IconContainer.prefix(
        child: widget.prefixIcon!,
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
          ),
          const SizedBox(height: 4),
        ],
        ReactiveTextField<T>(
          keyboardType: widget.keyboardType ?? TextInputType.text,
          formControl: widget.formControl,
          validationMessages: widget.validationMessages,
          onEditingComplete: (_) {
            widget.formControl.markAsTouched();
          },
          obscureText: _obscureText,
          obscuringCharacter: '*',
          decoration: const InputDecoration()
              .applyDefaults(
                Theme.of(context).inputDecorationTheme,
              )
              .copyWith(
                hintText: widget.hintText,
                helperText: widget.helperText,
                prefixIconConstraints: _iconConstraints,
                prefixIcon: _prefixIcon,
                suffixIconConstraints: _iconConstraints,
                suffixIcon: ReactiveStatusListenableBuilder(
                  formControl: widget.formControl,
                  builder: (_, control, __) {
                    print('invalid: ${control.invalid}');
                    print('touched ${control.touched}');
                    return _getSuffixIcon(control);
                  },
                ),
              ),
        ),
      ],
    );
  }
}

class _IconContainer extends StatelessWidget {
  const _IconContainer.suffix({
    required this.child,
    this.color,
    this.onTap,
  }) : isPrefix = false;

  const _IconContainer.prefix({
    required this.child,
    this.color,
    this.onTap,
  }) : isPrefix = true;

  final Widget child;
  final Color? color;
  final bool isPrefix;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: isPrefix ? 16 : 12,
          end: isPrefix ? 8 : 16,
        ),
        child: SizedBox(
          height: 20,
          width: 20,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              color ?? Theme.of(context).colorScheme.error,
              BlendMode.srcIn,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
