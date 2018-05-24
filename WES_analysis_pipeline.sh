# WES ANALYSIS
# --------------------------------
# Map to reference genome
bwa mem ../Homo_sapiens.GRCh37.GATK.illumina/Homo_sapiens.GRCh37.GATK.illumina.fasta ../datafiles/na12878_wes_brcagenes-1.fastq ../datafiles/na12878_wes_brcagenes-2.fastq > na12878_wes.sam

# Create BAM file
sambamba view -S -f bam na12878_wes.sam > na12878_wes.bam

# Sort the BAM file
sambamba sort na12878_wes.bam

# Mark duplicates
sambamba markdup \na12878_wes.sorted.bam \dedupped_na12878_wes.sorted.bam

# Add readgroups
java -jar $PICARD AddOrReplaceReadGroups \
I=dedupped_na12878_wes.sorted.bam \
O=RG_dedupped_na12878_wes.sorted.bam \
CREATE_INDEX=true \
RGLB=WES \
RGPL=illumina \
RGSM=na12878 \
RGPU=slide_barcode

# Call variants
java -jar $GATK \
-T HaplotypeCaller \
-R Homo_sapiens.GRCh37.GATK.illumina/Homo_sapiens.GRCh37.GATK.illumina.fasta  \
-L datafiles/brca_genes.bed \
-I RG_dedupped_na12878_wes.sorted.bam \
-o RG_dedupped_na12878_wes.sorted.vcf

# --------------------------------
# Some pointers on how to use bash:
# --------------------------------

# Bash variables
variable_name="Hello World!"
echo variable_name

# if / else
if_else_test="test"
if [ $if_else_test = "test" ]; then
    echo true
else
    echo false
fi

# For loop
for var in 1 2 3
do
    echo $var
done


# Create output dir, make sure to use full path
notebook_home=$HOME/Notebooks/
output_name="pipeline_out"
output_dir=$notebook_home/$output_name

# Only create the folder if it is not there!
if [ ! -d $output_dir ]; then
    mkdir $output_dir
fi

# --------------------------------
