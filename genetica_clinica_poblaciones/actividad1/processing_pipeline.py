import pandas as pd

# Función para extraer genes representativos de un archivo Excel
def get_representative_genes(file_path: str , miRNA: str):
    
    df = pd.read_excel(file_path)

    #Cojo los genes representativos para el miRNA dado
    genes = df['Gene name'].dropna().unique()

    #Los guardo en un archivo txt
    with open(f'generated_data/representative_genes_{miRNA}.txt', 'w') as f:
        for gene in genes:
            f.write(f"{gene}\n")

    return genes.tolist()


hsa_miR_33a_5p_genes = get_representative_genes('data/hsa-miR-33-5p.xlsx', 'hsa-miR-33a-5p')
hsa_miR_33b_5p_genes = get_representative_genes('data/hsa-miR-33-5p.xlsx', 'hsa-miR-33b-5p')
hsa_miR_106b_5p_genes = get_representative_genes('data/hsa-miR-106b-5p.xlsx', 'hsa-miR-106b-5p')
hsa_miR_144_3p_genes = get_representative_genes('data/hsa-miR-144-3p.xlsx', 'hsa-miR-144-3p')
hsa_miR_758_3p_genes = get_representative_genes('data/hsa-miR-758-3p.xlsx', 'hsa-miR-758-3p')

# Convierte cada lista en un set para operaciones de conjuntos
set_33a = set(hsa_miR_33a_5p_genes)
set_33b = set(hsa_miR_33b_5p_genes)
set_106b = set(hsa_miR_106b_5p_genes)
set_144 = set(hsa_miR_144_3p_genes)
set_758 = set(hsa_miR_758_3p_genes)

# Calcula los genes únicos de cada miRNA
unique_33a = set_33a - (set_33b | set_106b | set_144 | set_758)
unique_33b = set_33b - (set_33a | set_106b | set_144 | set_758)
unique_106b = set_106b - (set_33a | set_33b | set_144 | set_758)
unique_144 = set_144 - (set_33a | set_33b | set_106b | set_758)
unique_758 = set_758 - (set_33a | set_33b | set_106b | set_144)

#Calcula los genes comunes entre todos los miRNAs
common_genes = set_33a & set_33b & set_106b & set_144 & set_758

# Imprime los resultados
print("----------------------------------------------------------------")
print("Common genes among all miRNAs:", common_genes)


print("Representative genes for hsa-miR-33a-5p:", len(hsa_miR_33a_5p_genes))
print("Representative genes for hsa-miR-33b-5p:", len(hsa_miR_33b_5p_genes))
print("Representative genes for hsa-miR-106b-5p:", len(hsa_miR_106b_5p_genes))
print("Representative genes for hsa-miR-144-3p:", len(hsa_miR_144_3p_genes))
print("Representative genes for hsa-miR-758-3p:", len(hsa_miR_758_3p_genes))
print("----------------------------------------------------------------")
print("Unique genes for hsa-miR-33a-5p:", len(unique_33a))
print("Unique genes for hsa-miR-33b-5p:", len(unique_33b))
print("Unique genes for hsa-miR-106b-5p:", len(unique_106b))
print("Unique genes for hsa-miR-144-3p:", len(unique_144))
print("Unique genes for hsa-miR-758-3p:", len(unique_758))