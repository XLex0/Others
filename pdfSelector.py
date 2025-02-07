from PyPDF2 import PdfReader, PdfWriter

def extraer_paginas(pdf_entrada, pdf_salida, paginas):
    try:
        lector = PdfReader(pdf_entrada)
        escritor = PdfWriter()

        total_paginas = len(lector.pages)
        paginas_validas = [p for p in paginas if 0 < p <= total_paginas]

        if not paginas_validas:
            print(" No hay páginas válidas para extraer")
            return

        for num_pagina in paginas_validas:
            escritor.add_page(lector.pages[num_pagina - 1])  # Python indexa desde 0

        with open(pdf_salida, "wb") as output_pdf:
            escritor.write(output_pdf)

        print(f"Páginas {paginas_validas} extraídas correctamente a {pdf_salida}")

    except Exception as e:
        print(f"Error: {e}")

# Rutas de archivos 
# (Usa `r""` para evitar problemas con `\`)

pdf_entrada = r".\Principles of DDS.pdf"
pdf_salida = r".\capitulo_10.pdf"
paginas_a_extraer = list(range(356, 381))  # Extrae páginas de n a m-1 range(n, m)

extraer_paginas(pdf_entrada, pdf_salida, paginas_a_extraer)
