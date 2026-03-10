"use client";

import Image from "next/image";
import { CSSProperties } from "react";

type AetherisLogoProps = {
  className?: string;
  style?: CSSProperties;
};

export function AetherisLogo({ className = "", style }: AetherisLogoProps) {
  // Replace 'aetheris-logo.png' with your actual logo filename
  return (
    <Image
      src="/aetheris-logo.png"
      alt="Aetheris"
      width={400}
      height={160}
      priority
      className={className}
      style={style}
    />
  );
}
