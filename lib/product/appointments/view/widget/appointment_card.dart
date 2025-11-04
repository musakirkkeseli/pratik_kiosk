import 'package:flutter/material.dart';

import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/extension/text_theme_extension.dart';
import '../../../../features/utility/extension/color_extension.dart';

class AppointmentCard extends StatelessWidget {
  final String departmentName;
  final String branchName;
  final String appointmentTime;
  final String doctorName;
  final VoidCallback? onTap;

  const AppointmentCard({
    super.key,
    required this.departmentName,
    required this.appointmentTime,
    required this.doctorName,
    required this.branchName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      hoverColor: context.primaryColor.withOpacity(0.05),
      splashColor: context.primaryColor.withOpacity(0.1),
      highlightColor: context.primaryColor.withOpacity(0.05),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border(
            left: BorderSide(color: context.primaryColor, width: 8),
          ),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    branchName,
                    style: context.sectionTitle.copyWith(fontSize: 24),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: context.primaryColor.withOpacity(0.6),
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          context,
                          label: ConstantString().hour,
                          value: appointmentTime,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          context,
                          label: ConstantString().policlinic,
                          value: departmentName,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 32),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          context,
                          label: ConstantString().doctor,
                          value: doctorName,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          ConstantString().select,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.bodySecondary.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: context.primaryText.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
