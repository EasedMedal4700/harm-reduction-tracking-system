import 'package:flutter/material.dart';

/// Controls for adjusting metabolism timeline view parameters
class MetabolismTimelineControls extends StatelessWidget {
  final int hoursBack;
  final int hoursForward;
  final bool adaptiveScale;
  final Function(int) onHoursBackChanged;
  final Function(int) onHoursForwardChanged;
  final Function(bool) onAdaptiveScaleChanged;
  final Function(int, int)? onPresetSelected;
  
  const MetabolismTimelineControls({
    required this.hoursBack,
    required this.hoursForward,
    required this.adaptiveScale,
    required this.onHoursBackChanged,
    required this.onHoursForwardChanged,
    required this.onAdaptiveScaleChanged,
    this.onPresetSelected,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tune, size: 18),
              SizedBox(width: 8),
              Text(
                'Timeline Controls',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Hours back and forward inputs
          Row(
            children: [
              Expanded(
                child: _buildTimeInput(
                  label: 'Hours Back',
                  value: hoursBack,
                  onChanged: (val) => onHoursBackChanged(val ?? hoursBack),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTimeInput(
                  label: 'Hours Forward',
                  value: hoursForward,
                  onChanged: (val) => onHoursForwardChanged(val ?? hoursForward),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Scale toggle
          Row(
            children: [
              const Icon(Icons.vertical_align_top, size: 16),
              const SizedBox(width: 8),
              const Text('Y-Axis Scale:', style: TextStyle(fontSize: 13)),
              const Spacer(),
              _buildScaleButton('Fixed 100%', !adaptiveScale, () => onAdaptiveScaleChanged(false)),
              const SizedBox(width: 8),
              _buildScaleButton('Adaptive', adaptiveScale, () => onAdaptiveScaleChanged(true)),
            ],
          ),
          const SizedBox(height: 12),
          
          // Preset buttons
          const Text('Quick Presets:', style: TextStyle(fontSize: 12)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildPresetButton('24h', 12, 12, context),
              _buildPresetButton('48h', 24, 24, context),
              _buildPresetButton('72h', 24, 48, context),
              _buildPresetButton('1 Week', 72, 96, context),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildTimeInput({
    required String label,
    required int value,
    required Function(int?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: value.toString(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixText: 'h',
            suffixStyle: const TextStyle(fontSize: 12),
            filled: true,
            fillColor: Colors.white,
          ),
          style: const TextStyle(fontSize: 13),
          onFieldSubmitted: (val) {
            final parsed = int.tryParse(val);
            if (parsed != null && parsed > 0 && parsed <= 168) {
              onChanged(parsed);
            }
          },
        ),
      ],
    );
  }
  
  Widget _buildScaleButton(String label, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.cyan.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: selected ? Colors.cyan : Colors.grey,
            width: selected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? Colors.cyan[700] : Colors.grey[700],
          ),
        ),
      ),
    );
  }
  
  Widget _buildPresetButton(String label, int back, int forward, BuildContext context) {
    final isSelected = hoursBack == back && hoursForward == forward;
    
    return InkWell(
      onTap: () {
        if (onPresetSelected != null) {
          onPresetSelected!(back, forward);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.cyan.withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? Colors.cyan : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.cyan[700] : Colors.grey[700],
          ),
        ),
      ),
    );
  }
}
