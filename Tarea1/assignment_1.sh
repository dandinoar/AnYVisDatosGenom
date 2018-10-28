extension1=${1:-.fasta}
extension2=${2:-.fastq}
extension3=${3:-.bam}
#Make directories only if don't exist (-p)
mkdir -p raw_data
mkdir -p a_genome_index
mkdir -p b_alignment
mkdir -p c_variant_calling

########################
#Genome index (and log)#
########################
fasta=$(ls ./raw_data| grep -P "$extension1$")
echo "indexing '${fasta}' genome"
#bowtie2-build raw_data/$fasta a_genome_index/genome_index > a_genome_index/    log.index
echo "INDEX DONE. log file created: a_genome_index/log.index"


####################
#Alignmet (and log)#
####################
touch b_alignment/log.alignment
fastq=$(ls ./raw_data| grep $extension2)
#loops for multiples fastq files
splited=$(echo $fastq | tr " " "\n")
for i in $splited
    do
    echo "Alining '$i' file"
    echo "log for '$i' file alignment" >> b_alignment/log.alignment
    basename=${i%"$extension2"}
    #make .sam
#    bowtie2 -x a_genome_index/genome_index -U raw_data/$i -S   b_alignment/alignment_$basename.sam &>> b_alignment/log.alignment
    #Convert .sam to .bam
#    samtools view -bS b_alignment/alignment_$basename.sam > b_alignment/alignment_$basename.bam
    #Sort .bam file
    #samtools sort b_alignment/alignment_$basename.bam b_alignment/alignment_$basename\_sorted
    done
echo "ALIGNMENTS DONE. log file created: b_alignment/log.alignment"
##########################
#Varian Calling (and log)#
##########################
touch c_variant_calling/log.variant_calling
bam=$(ls ./b_alignment| grep "_sorted.bam")
#loops for multiples fastq files
splited=$(echo $bam | tr " " "\n")
for i in $splited
    do
    echo "Variant Calling in '$i' file"
    #echo "log for '$i' file call" >> c_variant_calling/log.variant_calling
    basename=${i%"$extension3"}
#samtools mpileup -g -f raw_data/$fasta b_alignment/sorted_$basename.bam > c_variant_calling/variants_$basename.bcf
    #Without indels (-I). Output .bcf (-g)
    samtools mpileup -g -f raw_data/$fasta b_alignment/$basename.bam >  c_variant_calling/variants_$basename.bcf
    bcftools view -vg c_variant_calling/variants_$basename.bcf > c_variant_calling/variants_$basename.vcf
 done
echo "VARIANT CALLING DONE. log file created: c_variant_calling/log.variant_calling"

