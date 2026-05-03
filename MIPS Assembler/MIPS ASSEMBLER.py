import tkinter as tk
from tkinter import ttk, filedialog, messagebox
import re
import os

FUNCT = {
    "add": "100000",
    "sub": "100010",
    "and": "100100",
    "or": "100101",
    "slt": "101010",
}

REGISTERS = {f"${i}": i for i in range(32)}

REGISTER_ALIASES = {
    "$zero": 0, "$at": 1,
    "$v0": 2, "$v1": 3,
    "$a0": 4, "$a1": 5, "$a2": 6, "$a3": 7,
    "$t0": 8, "$t1": 9, "$t2": 10, "$t3": 11,
    "$t4": 12, "$t5": 13, "$t6": 14, "$t7": 15,
    "$s0": 16, "$s1": 17, "$s2": 18, "$s3": 19,
    "$s4": 20, "$s5": 21, "$s6": 22, "$s7": 23,
    "$t8": 24, "$t9": 25,
    "$k0": 26, "$k1": 27,
    "$gp": 28, "$sp": 29, "$fp": 30, "$ra": 31,
}
REGISTERS.update(REGISTER_ALIASES)


def parse_register(token: str) -> int:
    token = token.strip().rstrip(",")
    if token in REGISTERS:
        return REGISTERS[token]
    raise ValueError(f"Registro invalido: '{token}'")


def parse_line(line: str, lineno: int) -> dict:
    line = re.sub(r"#.*", "", line).strip()
    if not line:
        return None

    tokens = re.split(r"[\s,]+", line)
    tokens = [t for t in tokens if t]

    if len(tokens) != 4:
        raise ValueError(
            f"Linea {lineno}: se esperaban 4 tokens (inst $rd, $rs, $rt), "
            f"se encontraron {len(tokens)}: {' '.join(tokens)}"
        )

    mnemonic = tokens[0].lower()
    if mnemonic not in FUNCT:
        raise ValueError(
            f"Linea {lineno}: instruccion '{mnemonic}' no es R-type soportada. "
            f"Instrucciones validas: {', '.join(FUNCT.keys())}"
        )

    try:
        rd = parse_register(tokens[1])
        rs = parse_register(tokens[2])
        rt = parse_register(tokens[3])
    except ValueError as e:
        raise ValueError(f"Linea {lineno}: {e}")

    return {
        "lineno": lineno,
        "mnemonic": mnemonic,
        "rd": rd,
        "rs": rs,
        "rt": rt,
        "original": line,
    }


def parse_asm(source: str) -> list:
    instructions = []
    for i, line in enumerate(source.splitlines(), start=1):
        result = parse_line(line, i)
        if result is not None:
            instructions.append(result)
    return instructions


def instr_to_binary(instr: dict) -> str:
    opcode = "000000"
    rs = format(instr["rs"], "05b")
    rt = format(instr["rt"], "05b")
    rd = format(instr["rd"], "05b")
    shamt = "00000"
    funct = FUNCT[instr["mnemonic"]]

    return opcode + rs + rt + rd + shamt + funct


def binary_to_bytes_big_endian(binary32: str) -> list:
    assert len(binary32) == 32
    return [binary32[i:i + 8] for i in range(0, 32, 8)]


def instructions_to_mem(instructions_bin: list) -> list:
    mem_bytes = []
    for b in instructions_bin:
        mem_bytes.extend(binary_to_bytes_big_endian(b))
    return mem_bytes


def assemble(source: str):
    parsed = parse_asm(source)
    if not parsed:
        raise ValueError("No se encontraron instrucciones validas en el archivo.")

    bin32_list = []
    details = []
    for instr in parsed:
        b = instr_to_binary(instr)
        bin32_list.append(b)
        details.append({
            "original": instr["original"],
            "binary32": b,
            "bytes": binary_to_bytes_big_endian(b),
        })

    mem_bytes = instructions_to_mem(bin32_list)
    return bin32_list, mem_bytes, details


BG = "#0D1117"
BG2 = "#161B22"
BG3 = "#21262D"
ACCENT = "#58A6FF"
ACCENT2 = "#3FB950"
WARN = "#F85149"
MUTED = "#8B949E"
FG = "#E6EDF3"
MONO = ("Consolas", 10)
MONO_LG = ("Consolas", 11)
TITLE_F = ("Consolas", 13, "bold")


class MIPSAssemblerApp:
    def __init__(self, root: tk.Tk):
        self.root = root
        self.root.title("MIPS R-Type Assembler  //  DPTR Compatible")
        self.root.geometry("1100x740")
        self.root.configure(bg=BG)
        self.root.resizable(True, True)

        self._mem_bytes = []
        self._build_ui()

    def _build_ui(self):
        hdr = tk.Frame(self.root, bg=BG, pady=8)
        hdr.pack(fill="x", padx=20)

        tk.Label(
            hdr, text="◈ MIPS R-TYPE ASSEMBLER",
            bg=BG, fg=ACCENT, font=("Consolas", 16, "bold")
        ).pack(side="left")

        tk.Label(
            hdr, text="  [add · sub · and · or · slt]  →  Big-Endian .mem",
            bg=BG, fg=MUTED, font=("Consolas", 10)
        ).pack(side="left", pady=6)

        tk.Frame(self.root, bg=BG3, height=1).pack(fill="x", padx=20, pady=2)

        toolbar = tk.Frame(self.root, bg=BG, pady=6)
        toolbar.pack(fill="x", padx=20)

        self._btn_load = self._button(toolbar, "⬆  Cargar .asm", self._load_file, ACCENT)
        self._btn_convert = self._button(toolbar, "⚙  Convertir", self._convert, ACCENT2)
        self._btn_export = self._button(toolbar, "💾  Exportar .mem", self._export_mem, "#E3B341")
        self._btn_clear = self._button(toolbar, "✕  Limpiar", self._clear, MUTED)

        self._btn_load.pack(side="left", padx=(0, 8))
        self._btn_convert.pack(side="left", padx=(0, 8))
        self._btn_export.pack(side="left", padx=(0, 8))
        self._btn_clear.pack(side="left")

        self._status = tk.Label(
            toolbar, text="Listo.", bg=BG, fg=MUTED, font=("Consolas", 9)
        )
        self._status.pack(side="right")

        main = tk.Frame(self.root, bg=BG)
        main.pack(fill="both", expand=True, padx=20, pady=(4, 0))
        main.columnconfigure(0, weight=2)
        main.columnconfigure(1, weight=3)
        main.columnconfigure(2, weight=2)
        main.rowconfigure(0, weight=1)

        self._asm_text = self._panel(
            main, col=0,
            title="▸ CODIGO ENSAMBLADOR (.asm)",
            title_color=ACCENT,
        )
        self._asm_text.configure(insertbackground=ACCENT)

        self._bin_text = self._panel(
            main, col=1,
            title="▸ INSTRUCCIONES BINARIAS (32 bits)",
            title_color=ACCENT2,
            editable=False,
        )

        self._mem_text = self._panel(
            main, col=2,
            title="▸ BYTES DE MEMORIA (8 bits/linea)",
            title_color="#E3B341",
            editable=False,
        )

        legend = tk.Frame(self.root, bg=BG2, pady=6)
        legend.pack(fill="x", padx=0, pady=(6, 0))

        legend_txt = (
            "  Formato R-Type:  opcode[6]=000000  |  rs[5]  |  rt[5]  |  rd[5]  |  "
            "shamt[5]=00000  |  funct[6]   —   Big-Endian (MSB primero)  "
        )
        tk.Label(
            legend, text=legend_txt,
            bg=BG2, fg=MUTED, font=("Consolas", 8)
        ).pack(side="left")

    def _button(self, parent, text, cmd, color):
        return tk.Button(
            parent, text=text, command=cmd,
            bg=BG3, fg=color, activebackground=BG2, activeforeground=color,
            relief="flat", font=("Consolas", 9, "bold"),
            padx=12, pady=5, cursor="hand2",
            highlightthickness=1, highlightbackground=color,
        )

    def _panel(self, parent, col, title, title_color, editable=True):
        frame = tk.Frame(parent, bg=BG2, relief="flat",
                         highlightthickness=1, highlightbackground=BG3)
        frame.grid(row=0, column=col, sticky="nsew",
                   padx=(0 if col == 0 else 6, 0), pady=0)
        frame.rowconfigure(1, weight=1)
        frame.columnconfigure(0, weight=1)

        tk.Label(
            frame, text=title, bg=BG2, fg=title_color,
            font=("Consolas", 9, "bold"), anchor="w", padx=10, pady=6,
        ).grid(row=0, column=0, sticky="ew")

        tk.Frame(frame, bg=BG3, height=1).grid(row=0, column=0, sticky="ew",
                                               padx=0, pady=(26, 0))

        text = tk.Text(
            frame, bg=BG, fg=FG, font=MONO,
            insertbackground=FG, relief="flat",
            padx=10, pady=8, wrap="none",
            selectbackground=BG3, selectforeground=ACCENT,
            state="normal" if editable else "disabled",
            spacing1=2, spacing3=2,
        )
        text.grid(row=1, column=0, sticky="nsew")

        sb_y = ttk.Scrollbar(frame, orient="vertical", command=text.yview)
        sb_x = ttk.Scrollbar(frame, orient="horizontal", command=text.xview)
        text.configure(yscrollcommand=sb_y.set, xscrollcommand=sb_x.set)
        sb_y.grid(row=1, column=1, sticky="ns")
        sb_x.grid(row=2, column=0, sticky="ew")

        return text

    def _set_status(self, msg, color=MUTED):
        self._status.configure(text=msg, fg=color)

    def _load_file(self):
        path = filedialog.askopenfilename(
            title="Seleccionar archivo .asm",
            filetypes=[("Archivos ASM", "*.asm"), ("Todos", "*.*")]
        )
        if not path:
            return
        try:
            with open(path, "r", encoding="utf-8") as f:
                content = f.read()
            self._asm_text.delete("1.0", "end")
            self._asm_text.insert("1.0", content)
            self._set_status(f"Archivo cargado: {os.path.basename(path)}", ACCENT)
        except Exception as e:
            messagebox.showerror("Error al cargar", str(e))

    def _convert(self):
        source = self._asm_text.get("1.0", "end").strip()
        if not source:
            messagebox.showwarning("Sin contenido", "Escribe o carga codigo ASM primero.")
            return

        try:
            bin32_list, mem_bytes, details = assemble(source)
        except ValueError as e:
            self._set_status(f"Error: {e}", WARN)
            messagebox.showerror("Error de ensamblado", str(e))
            return

        self._mem_bytes = mem_bytes

        self._bin_text.configure(state="normal")
        self._bin_text.delete("1.0", "end")

        for d in details:
            b = d["binary32"]
            self._bin_text.insert("end", f"; {d['original']}\n")
            fields = (
                ("opcode ", b[0:6]),
                (" rs ", b[6:11]),
                (" rt ", b[11:16]),
                (" rd ", b[16:21]),
                (" shamt ", b[21:26]),
                (" funct ", b[26:32]),
            )
            for label, bits in fields:
                self._bin_text.insert("end", label + bits)
            self._bin_text.insert("end", "\n")
            self._bin_text.insert("end", f"→ {b}\n\n")

        self._bin_text.configure(state="disabled")

        self._mem_text.configure(state="normal")
        self._mem_text.delete("1.0", "end")

        addr = 0
        for i, d in enumerate(details):
            self._mem_text.insert("end", f"; instruccion {i + 1}: {d['original']}\n")
            for byte_str in d["bytes"]:
                self._mem_text.insert("end", f"[{addr:03d}] {byte_str}\n")
                addr += 1
            self._mem_text.insert("end", "\n")

        self._mem_text.configure(state="disabled")

        n = len(details)
        self._set_status(
            f"{n} instrucciones ensambladas → {n * 4} bytes generados.",
            ACCENT2
        )

    def _export_mem(self):
        if not self._mem_bytes:
            messagebox.showwarning(
                "Sin datos", "Primero convierte el codigo ASM."
            )
            return
        path = filedialog.asksaveasfilename(
            title="Guardar archivo .mem",
            defaultextension=".mem",
            filetypes=[("Archivos MEM", "*.mem"), ("Texto", "*.txt")]
        )
        if not path:
            return
        try:
            with open(path, "w", encoding="utf-8") as f:
                for byte_str in self._mem_bytes:
                    f.write(byte_str + "\n")
            self._set_status(
                f"Exportado: {os.path.basename(path)} ({len(self._mem_bytes)} bytes)",
                "#E3B341"
            )
            messagebox.showinfo(
                "Exportacion exitosa",
                f"Archivo guardado en:\n{path}\n\n{len(self._mem_bytes)} bytes escritos."
            )
        except Exception as e:
            messagebox.showerror("Error al exportar", str(e))

    def _clear(self):
        self._asm_text.delete("1.0", "end")
        for t in (self._bin_text, self._mem_text):
            t.configure(state="normal")
            t.delete("1.0", "end")
            t.configure(state="disabled")
        self._mem_bytes = []
        self._set_status("Listo.", MUTED)


def main():
    root = tk.Tk()

    style = ttk.Style(root)
    style.theme_use("clam")

    app = MIPSAssemblerApp(root)
    root.mainloop()


if __name__ == "__main__":
    main()