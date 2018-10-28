extension1=${1:-.fasta}
extension2=${2:-.fastq}
touch log.coverage

#Genome length (G)
fasta=$(ls ./raw_data| grep -P "$extension1$")
echo "indexing '${fasta}' genome"
G=$(grep -v ">" ./raw_data/${fasta} | wc -m)
echo "GENOME LENGTH=$G."
echo "GENOME LENGTH (G)=$G" >> log.coverage


#COVERAGE FOR EACH FASTQ
fastq=$(ls ./raw_data| grep $extension2)
#loops for multiples fastq files
splited=$(echo $fastq | tr " " "\n")
for i in $splited
    do
    echo "File '$i':"
    echo "File '$i':" >> log.coverage
    #N=$(wc -l ./raw_data/$i | awk '{print $1}')
    #N=$((N/4))
    #total bases in file
    LN=$(grep -Pv "[^ACGT]" ./raw_data/$i | wc -m)
    echo "Sequenced bases: $LN"
    echo "Sequenced bases: $LN" >> log.coverage
    C=$((LN/G))
    C=$(echo "scale=2; $LN/$G" | bc)
    echo "Coverage: $C"
    echo "Coverage: $C" >> log.coverage
    #basename=${i%"$extension2"}
   
    done

