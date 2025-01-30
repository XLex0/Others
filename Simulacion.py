import numpy as np
import random
import matplotlib.pyplot as plt
import tkinter as tk
from tkinter import messagebox, scrolledtext
from tkinter import ttk
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg

direcciones_virtuales = []
paso_actual = 0
cola_paginas = []
politica_reemplazo = "FIFO"  

# Función para iniciar la simulación
def iniciar_simulacion():
    global TAM_MEMORIA_FISICA, TAM_MEMORIA_VIRTUAL, tabla_paginas, marcos_en_ram, direcciones_virtuales, paso_actual, cola_paginas, politica_reemplazo
    
    try:
        TAM_MEMORIA_VIRTUAL = int(entrada_memoria_virtual.get())
        TAM_MEMORIA_FISICA = int(entrada_memoria_fisica.get())
        
        if not (4 <= TAM_MEMORIA_VIRTUAL <= 15 and 4 <= TAM_MEMORIA_FISICA <= 8):
            raise ValueError("Valores fuera del rango permitido.")
        
        politica_reemplazo = combo_politica.get()  # Obtener la política seleccionada

    except ValueError:
        messagebox.showerror("Error", "Ingrese valores válidos dentro del rango permitido.")
        return
    
    # Inicializar estructuras de datos
    tabla_paginas = {i: -1 for i in range(TAM_MEMORIA_VIRTUAL)}
    marcos_en_ram = []
    direcciones_virtuales = [random.randint(0, TAM_MEMORIA_VIRTUAL * TAM_PAGINA - 1) for _ in range(10)]
    paso_actual = 0
    cola_paginas = []
    

    root.withdraw()
    iniciar_pantalla_simulacion()

def traducir_direccion(virtual):
    pagina = virtual // TAM_PAGINA  
    offset = virtual % TAM_PAGINA  
    
    if tabla_paginas[pagina] == -1:  
        manejar_page_fault(pagina)
    
    marco = tabla_paginas[pagina]
    fisica = marco * TAM_PAGINA + offset
    return fisica

def manejar_page_fault(pagina):
    global marcos_en_ram, cola_paginas, politica_reemplazo
    
    if len(marcos_en_ram) >= TAM_MEMORIA_FISICA:  # Si la RAM está llena
        if politica_reemplazo == "FIFO":
            pagina_reemplazada = marcos_en_ram.pop(0)  # FIFO: Sacamos la más antigua
        elif politica_reemplazo == "LRU":
            pagina_reemplazada = cola_paginas.pop(0)  # LRU: Sacamos la más antigua, la que menos se ha usado
        
        tabla_paginas[pagina_reemplazada] = -1
    

    nuevo_marco = len(marcos_en_ram)
    tabla_paginas[pagina] = nuevo_marco
    marcos_en_ram.append(pagina)
    cola_paginas.append(pagina)
    
    actualizar_canvas()
    actualizar_cola()

def actualizar_canvas():
    fig, ax = plt.subplots(figsize=(6, 6))
    ax.clear()
    
    for i in range(TAM_MEMORIA_FISICA):
        if i < len(marcos_en_ram):
            ax.text(0.5, TAM_MEMORIA_FISICA - i - 0.5, f"P{marcos_en_ram[i]}", 
                    fontsize=12, ha='center', va='center', 
                    bbox=dict(facecolor='lightblue', edgecolor='black'))
        ax.plot([0, 1], [i, i], 'k', lw=2)
    
    ax.plot([0, 1], [TAM_MEMORIA_FISICA, TAM_MEMORIA_FISICA], 'k', lw=2)
    ax.plot([0, 0], [0, TAM_MEMORIA_FISICA], 'k', lw=2)
    ax.plot([1, 1], [0, TAM_MEMORIA_FISICA], 'k', lw=2)
    ax.set_xticks([])  
    ax.set_yticks([])  
    ax.set_title("Estado de la RAM")
    
    canvas.figure = fig
    canvas.draw()

def actualizar_cola():
    cola_text.config(state=tk.NORMAL)
    cola_text.delete(1.0, tk.END)
    cola_text.insert(tk.END, " → ".join(map(str, cola_paginas)))
    cola_text.config(state=tk.DISABLED)

def siguiente_paso():
    global paso_actual
    if paso_actual < len(direcciones_virtuales):
        virtual = direcciones_virtuales[paso_actual]
        fisica = traducir_direccion(virtual)
        label_info.config(text=f"Paso {paso_actual + 1}: Virtual {virtual} → Física {fisica}")
        paso_actual += 1
    else:
        label_info.config(text="Simulación completada.")
    actualizar_cola()

def iniciar_pantalla_simulacion():
    global ventana_simulacion, label_info, canvas, cola_text
    
    ventana_simulacion = tk.Toplevel(root)
    ventana_simulacion.title("Simulación de Paginación")
    ventana_simulacion.geometry("900x600")
    
    frame_izq = tk.Frame(ventana_simulacion)
    frame_izq.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
    
    tk.Label(frame_izq, text="Presione siguiente para ver cada paso:").pack()
    label_info = tk.Label(frame_izq, text="")
    label_info.pack()
    tk.Button(frame_izq, text="Siguiente", command=siguiente_paso).pack()
    
    fig, ax = plt.subplots(figsize=(6, 6))
    canvas = FigureCanvasTkAgg(fig, master=frame_izq)
    canvas.get_tk_widget().pack()
    
    frame_der = tk.Frame(ventana_simulacion, width=200)
    frame_der.pack(side=tk.RIGHT, fill=tk.Y)
    
    tk.Label(frame_der, text="Cola de páginas en RAM:").pack()
    cola_text = scrolledtext.ScrolledText(frame_der, height=5, width=30, state=tk.DISABLED)
    cola_text.pack()
    
    actualizar_canvas()

# Crear ventana principal
root = tk.Tk()
root.title("Simulación de Paginación")
root.geometry("300x250")


tk.Label(root, text="Tamaño de Memoria Virtual (4-15):").pack()
entrada_memoria_virtual = tk.Entry(root)
entrada_memoria_virtual.pack()
entrada_memoria_virtual.insert(0, "8")

tk.Label(root, text="Tamaño de Memoria Física (4-8):").pack()
entrada_memoria_fisica = tk.Entry(root)
entrada_memoria_fisica.pack()
entrada_memoria_fisica.insert(0, "4")


tk.Label(root, text="Política de Reemplazo:").pack()
combo_politica = ttk.Combobox(root, values=["FIFO", "LRU"], state="readonly")
combo_politica.pack()
combo_politica.set("FIFO")  # Valor predeterminado

tk.Button(root, text="Iniciar Simulación", command=iniciar_simulacion).pack()

TAM_PAGINA = 1
root.mainloop()
