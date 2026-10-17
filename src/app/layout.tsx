import type { Metadata, Viewport } from "next";
import { VT323 } from "next/font/google";
import "./globals.css";

const dosFont = VT323({
  weight: "400",
  subsets: ["latin"],
  variable: "--font-dos",
});

export const metadata: Metadata = {
  title: "Exam Week",
  description: "A DOS-style choose-your-own-adventure about school life.",
};

export const viewport: Viewport = {
  width: "device-width",
  initialScale: 1,
  themeColor: "#000000",
};

export default function RootLayout({ children }: LayoutProps<"/">) {
  return (
    <html lang="en" className={dosFont.variable}>
      <body className="font-mono">{children}</body>
    </html>
  );
}
