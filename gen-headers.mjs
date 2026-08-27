#!/usr/bin/env node
/**
 * Generates terminal-style "command chip" header SVGs used as section
 * titles in README.md, matching the green terminal aesthetic of the
 * dark.svg / light.svg banner.
 *
 * Run: node gen-headers.mjs   ->   writes files into assets/
 */

import fs from "node:fs";
import path from "node:path";

const OUT_DIR = path.resolve("assets");
const CHAR_W = 9;      // monospace advance at font-size 15
const PAD_X = 18;      // left/right text padding inside the chip
const HEIGHT = 36;
const FONT = "'Courier New',Consolas,monospace";

/** [outputFileName, "$ command text"] */
const HEADERS = [
  ["h-telemetry.svg", "$ git log --graph -- commit telemetry"],
  ["h-streak.svg", "$ streak --current"],
  ["h-langs.svg", "$ du -sh langs/*"],
  ["h-uptime.svg", "$ uptime --hours"],
  ["h-snake.svg", "$ snake --eat contributions"],
  ["h-skills.svg", "$ ls /usr/bin/skills"],
  ["h-ping.svg", "$ ping mldtmakbar"],
];

function escapeXml(s) {
  return s
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;");
}

function buildChip(text) {
  const width = Math.round(text.length * CHAR_W + PAD_X * 2);
  // Split "$" (green) from the rest of the command (light gray).
  const rest = text.startsWith("$ ") ? text.slice(1) : text;
  const restEsc = escapeXml(rest);
  return `<svg xmlns="http://www.w3.org/2000/svg" width="${width}" height="${HEIGHT}" viewBox="0 0 ${width} ${HEIGHT}">
  <defs>
    <linearGradient id="chipBorder" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" stop-color="#26a641"/>
      <stop offset="50%" stop-color="#39d353"/>
      <stop offset="100%" stop-color="#7ee787"/>
    </linearGradient>
  </defs>
  <rect x="1" y="1" width="${width - 2}" height="${HEIGHT - 2}" rx="9" fill="#0b1120" fill-opacity="0.9" stroke="url(#chipBorder)" stroke-width="1.4" opacity="0.9"/>
  <text x="${PAD_X}" y="24" font-family="${FONT}" font-size="15" font-weight="bold">
    <tspan fill="#39d353">$</tspan><tspan fill="#c9d1d9">${restEsc}</tspan>
  </text>
</svg>`;
}

fs.mkdirSync(OUT_DIR, { recursive: true });
for (const [file, text] of HEADERS) {
  const svg = buildChip(text);
  fs.writeFileSync(path.join(OUT_DIR, file), svg, "utf8");
  console.log(`Wrote assets/${file} (${text})`);
}
