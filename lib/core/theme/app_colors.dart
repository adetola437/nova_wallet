import 'package:flutter/material.dart';

/// NovaPay design tokens (Claude Design board `1a`).
///
/// Rule from the board: gold is never used for text on white — it appears as
/// fill, rule, progress and the brand mark only. [goldInk800] is the text-safe
/// substitute. Status is always shown as a tinted background + darker ink pair,
/// with an icon and a label, never by colour alone.
abstract class AppColors {
  // ── Brand ───────────────────────────────────────────────────────────────
  static const Color navy900 = Color(0xFF0A1E38);
  static const Color navy700 = Color(0xFF14355C);
  static const Color gold500 = Color(0xFFE0A526);
  static const Color goldInk800 = Color(0xFF8A5F06);

  // ── Neutrals ────────────────────────────────────────────────────────────
  static const Color appBg = Color(0xFFF6F5F2);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE6E3DC);
  static const Color textPrimary = navy900;
  static const Color textSecondary = Color(0xFF5C6779);
  static const Color textTertiary = Color(0xFF8A93A3);
  static const Color onNavy = Color(0xFFFFFFFF);
  static const Color onNavyMuted = Color(0xFFB9C3D3);

  // ── Status pairs (tinted background / darker ink) ───────────────────────
  static const Color sentBg = Color(0xFFE3F3E8);
  static const Color sentInk = Color(0xFF0F6435);
  static const Color pendingBg = Color(0xFFFBEFD3);
  static const Color pendingInk = Color(0xFF7A5309);
  static const Color sendingBg = Color(0xFFE6EDFB);
  static const Color sendingInk = Color(0xFF14459B);
  static const Color failedBg = Color(0xFFFBE7E7);
  static const Color failedInk = Color(0xFFA31C1C);

  // ── Semantic aliases ────────────────────────────────────────────────────
  static const Color primary = navy900;
  static const Color accent = gold500;
  static const Color accentInk = goldInk800;
  static const Color error = failedInk;
}
