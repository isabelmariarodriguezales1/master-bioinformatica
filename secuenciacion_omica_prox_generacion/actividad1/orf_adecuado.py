
#Reads the content of a file and returns it as a string
def read_file(file_path):
    
    seq = []
    with open(file_path, 'r') as file:
        for line in file:
            if not line.startswith('>'):
                seq.append(line.strip())

    return ''.join(seq)

#Checks if a given DNA sequence is a plausible Open Reading Frame (ORF)
def plausible_ORF(sequence):
    start_codon = 'ATG'
    stop_codons = ['TAA', 'TAG', 'TGA']
    
    sequence = sequence.upper().replace('\n', '').replace(' ', '')

    result = {}

    result['correct_start'] = sequence.startswith(start_codon)
    result['correct_stop'] = any(sequence.endswith(stop) for stop in stop_codons)
    result['length_multiple_of_3'] = len(sequence) % 3 == 0

    #Internal stop codons check
    internal_stops = []
    for i in range(0, len(sequence) - 3, 3):
        codon = sequence[i:i+3]
        if codon in stop_codons:
            internal_stops.append((i, codon))

    result['internal_stops'] = internal_stops

    #Aminoacid length
    aa_length = len(sequence) // 3
    result['aminoacid_length'] = aa_length
    result['adecuate_length'] = aa_length >= 150
    
    result['is_plausible_orf'] = (result['correct_start'] and
                                 result['correct_stop'] and
                                 result['length_multiple_of_3'] and
                                 result['adecuate_length'] and
                                 len(internal_stops) == 0)

    return result


# Example usage
archivos = ["data/orf1.txt", "data/orf13.txt", "data/orf16.txt"]

for archivo in archivos:
    seq = read_file(archivo)
    resultado = plausible_ORF(seq)
    for k, v in resultado.items():
        print(f"archivo {archivo} - {k}: {v}")
