import 'dart:ui';
// abstract class ColorManager{
//   static Color background = Color(0xFFFFFFFF);
//   static Color darkBackground = Color(0xFF0F1419);
//   static Color buttonColor = Color(0xFF1D61E7);
//   static Color gradientStart = Color(0xFF4894FE);
//   static Color gradientEnd = Color(0xFF3996DA);
//   static Color white = Color(0xFFFFFFFF);
//   static Color white70 = Color(0xB2FFFFFF);
// }
import 'package:flutter/material.dart';

// ─────────────────────────────────────────
//  APP COLORS  —  Light & Dark
// ─────────────────────────────────────────
class ColorManager {
  // ── Brand ──────────────────────────────
  static const blue       = Color(0xFF3B82F6);
  static const blueDark   = Color(0xFF2563EB);
  static const sky        = Color(0xFF0EA5E9);
  static const skyDark    = Color(0xFF0284C7);
  static const emerald    = Color(0xFF10B981);
  static const emeraldDk  = Color(0xFF059669);
  static const purple     = Color(0xFF8B5CF6);
  static const amber      = Color(0xFFF59E0B);

  // ── Dark theme ─────────────────────────
  static const darkBg           = Color(0xFF0F172A);
  static const darkCard         = Color(0xFF1E293B);
  static const darkCardDeep     = Color(0xFF162032);
  static const darkDivider      = Color(0x0DFFFFFF);   // 5%
  static const darkBorder       = Color(0x12FFFFFF);   // 7%
  static const darkProfileBg    = Color(0x08FFFFFF);   // 3%
  static const darkTextPrimary  = Color(0xFFF1F5F9);
  static const darkTextSecond   = Color(0xFF475569);
  static const darkTextMuted    = Color(0xFF334155);
  static const darkIconMuted    = Color(0xFF475569);
  static const darkToggleOff    = Color(0x1AFFFFFF);   // 10%
  static const darkHomeBar      = Color(0x12FFFFFF);   // 7%

  // Camera card (dark)
  static const darkCameraIconBg   = Color(0x263B82F6); // 15%
  static const darkCameraIcon     = Color(0xFF60A5FA);
  static const darkCameraBorder   = Color(0x333B82F6); // 20%
  static const darkCameraGlow     = Color(0x1F3B82F6); // 12%

  // Gate card (dark)
  static const darkGateIconBg     = Color(0x2610B981); // 15%
  static const darkGateIcon       = Color(0xFF34D399);
  static const darkGateBorder     = Color(0x3310B981); // 20%
  static const darkGateGlow       = Color(0x1F10B981); // 12%

  // Small cards accent bg (dark)
  static const darkBlueAccent     = Color(0x1F3B82F6);
  static const darkSkyAccent      = Color(0x1F0EA5E9);
  static const darkPurpleAccent   = Color(0x1F8B5CF6);
  static const darkAmberAccent    = Color(0x1FF59E0B);

  // ── Light theme ────────────────────────
  static const lightBg           = Color(0xFFEFF6FF);
  static const lightPhone        = Color(0xFFFFFFFF);
  static const lightDivider      = Color(0xFFF1F5F9);
  static const lightBorder       = Color(0xFFE2E8F0);
  static const lightProfileBg    = Color(0xFFF8FAFC);
  static const lightTextPrimary  = Color(0xFF1E293B);
  static const lightTextSecond   = Color(0xFF94A3B8);
  static const lightTextMuted    = Color(0xFF94A3B8);
  static const lightIconMuted    = Color(0xFF94A3B8);
  static const lightToggleOff    = Color(0xFFE2E8F0);
  static const lightHomeBar      = Color(0xFFE2E8F0);
  static const lightTopIconBg    = Color(0xFFEFF6FF);
  static const lightTopIconBorder= Color(0xFFBFDBFE);
  static const lightMenuBg       = Color(0xFFF8FAFC);

  // Camera card (light)
  static const lightCameraIconBg  = Color(0x1A3B82F6); // 10%
  static const lightCameraBorder  = Color(0x2E3B82F6); // 18%
  static const lightCameraGlow    = Color(0x1A3B82F6); // 10%

  // Gate card (light)
  static const lightGateIconBg    = Color(0x1A059669); // 10%
  static const lightGateBorder    = Color(0x2E059669); // 18%
  static const lightGateGlow      = Color(0x1A059669); // 10%

  // Small cards accent bg (light)
  static const lightBlueAccent    = Color(0x1A3B82F6);
  static const lightSkyAccent     = Color(0x1A0EA5E9);
  static const lightPurpleAccent  = Color(0x1A8B5CF6);
  static const lightAmberAccent   = Color(0x1AF59E0B);
  static const red       = Color(0xFFEF4444);
  static const lightCard = Color(0xFFFFFFFF);
}