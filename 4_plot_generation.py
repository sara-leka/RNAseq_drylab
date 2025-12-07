import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

df = pd.read_csv('general_stats_table.tsv', sep='\t')

avg_seqs = df['Seqs'].mean()
avg_len = df['Median len'].mean()

plt.figure(figsize=(6, 3)) 
sns.set_style("whitegrid") 
sns.violinplot(x=df['Seqs'], color="skyblue", inner=None, linewidth=1.5)
sns.stripplot(x=df['Seqs'], color="#40466e", size=5, jitter=True, alpha=0.8)
plt.text(x=df['Seqs'].max(), y=-0.45, s=f"Mean: {avg_seqs:.1f}M", 
         horizontalalignment='right', color='#40466e', fontweight='bold', fontsize=11,
         bbox=dict(facecolor='white', alpha=0.8, edgecolor='#cccccc', boxstyle='round,pad=0.3'))
plt.xlabel("Number of Sequences (Millions)", fontsize=12, fontweight='bold')
plt.title("Distribution of Library Sizes", fontsize=14, fontweight='bold')

plt.tight_layout()
plt.savefig('compact_violin_plot.png', dpi=300)
plt.show()


plt.figure(figsize=(6, 3))
sns.set_style("whitegrid")
sns.violinplot(x=df['Median len'], color="lightgreen", inner=None, linewidth=1.5)
sns.stripplot(x=df['Median len'], color="#2e5a32", size=5, jitter=True, alpha=0.8)
plt.text(x=df['Median len'].max(), y=-0.45, s=f"Mean: {avg_len:.1f} bp", 
         horizontalalignment='right', color='#2e5a32', fontweight='bold', fontsize=11,
         bbox=dict(facecolor='white', alpha=0.8, edgecolor='#cccccc', boxstyle='round,pad=0.3'))
plt.xlabel("Average Sequence Length (bp)", fontsize=12, fontweight='bold')
plt.title("Distribution of Sequence Lengths", fontsize=14, fontweight='bold')

plt.tight_layout()
plt.savefig('violin_avg_len.png', dpi=300)
plt.show()
