---
name: data-analysis
description: "Local data analysis and visualization skill, outputs structured JSON for downstream code consumption. Use when: (1) analyzing CSV/Excel/JSON data files, (2) exploring datasets, finding patterns, generating insights, (3) creating visualizations (chart/graph/dashboard), (4) assessing data quality or generating statistical reports. Keywords: 分析数据, 可视化, 图表, visualize, pattern, insight"
---

# Data Analysis

## 0. Temporary File Management

All temporary code and intermediate artifacts generated during analysis should be written to the project's `tmp/` directory:

```text
<project_root>/
├── tmp/                          # Analysis temp directory
│   ├── analysis_scripts/         # Temporary analysis scripts
│   │   └── sales_2023_analysis.py
│   ├── intermediate/             # Intermediate artifacts
│   │   ├── sales_2023_cleaned.csv
│   │   └── sales_2023_correlation.csv
│   └── output/                   # Final analysis output
│       ├── sales_2023_analysis.json
│       └── visualizations/
│           ├── sales_2023_age_vs_amount.png
│           └── sales_2023_amount_distribution.png
```

### Semantic File Naming

Use descriptive names based on data source and analysis purpose for easy retrieval in subsequent conversations:

| Pattern | Example | Description |
| ------- | ------- | ----------- |
| `{dataset}_{purpose}.py` | `sales_2023_analysis.py` | Analysis script |
| `{dataset}_{stage}.csv` | `sales_2023_cleaned.csv` | Intermediate data |
| `{dataset}_{analysis_type}.json` | `sales_2023_exploratory.json` | Analysis result |
| `{dataset}_{chart_desc}.png` | `sales_2023_age_vs_amount.png` | Visualization |

**Naming best practices**:
- Derive base name from source file: `sales_2023.csv` → `sales_2023_*`
- Include analysis focus: `sales_2023_correlation.json`, `sales_2023_outliers.json`
- Use snake_case for consistency
- Avoid UUIDs or timestamps in primary filenames (use for deduplication only if needed)

### Usage Guidelines

1. **Create directories on first use**:
   ```python
   import os
   from pathlib import Path

   # Get project root (data file directory or current working directory)
   project_root = Path.cwd()
   tmp_dir = project_root / "tmp"

   # Create subdirectories
   (tmp_dir / "analysis_scripts").mkdir(parents=True, exist_ok=True)
   (tmp_dir / "intermediate").mkdir(parents=True, exist_ok=True)
   (tmp_dir / "output" / "visualizations").mkdir(parents=True, exist_ok=True)
   ```

2. **Script naming**: Use semantic names based on dataset and purpose
   ```python
   # Derive name from source file
   source_file = "sales_2023.csv"
   base_name = Path(source_file).stem  # "sales_2023"
   script_path = tmp_dir / "analysis_scripts" / f"{base_name}_analysis.py"
   ```

3. **Intermediate artifacts**: Write cleaned data, transformed results to `tmp/intermediate/`

4. **Final output**: Write JSON results and visualizations to `tmp/output/`

5. **gitignore**: Ensure `tmp/` is added to `.gitignore`

### Why Use Project tmp/ Directory

| Benefit | Description |
| ------- | ----------- |
| Traceable | Artifacts are associated with the project for easy review |
| Reproducible | Intermediate scripts are retained for re-execution and verification |
| Isolated | Does not pollute system temp directories |
| Easy cleanup | Delete `tmp/` to remove all analysis artifacts at once |

### Copying Output to Source Directory for Code Reference

When the analysis JSON needs to be consumed by application code, copy it from `tmp/output/` to `shared/static/`:

```python
import shutil
from pathlib import Path

# Copy final JSON to shared/static/ for code reference
def export_to_shared(analysis_file: Path, dest_dir: Path = None, filename: str = None):
    """
    Copy analysis result JSON to shared/static/ for downstream code consumption.

    Args:
        analysis_file: Path to the analysis JSON in tmp/output/
        dest_dir: Target directory (defaults to shared/static/)
        filename: Optional custom filename (defaults to original name)
    """
    if dest_dir is None:
        dest_dir = Path("shared/static")
    dest_dir.mkdir(parents=True, exist_ok=True)
    dest_file = dest_dir / (filename or analysis_file.name)
    shutil.copy2(analysis_file, dest_file)
    print(f"Exported to: {dest_file}")
    return dest_file

# Example usage (copy to shared/static for direct import in code):
# export_to_shared(
#     analysis_file=Path("tmp/output/sales_2023_exploratory.json")
# )
# # Output: shared/static/sales_2023_exploratory.json
# # Import in code: import analysisData from '@shared/static/sales_2023_exploratory.json'
```

**Recommended destination directory**: `shared/static/`

This directory is for shared data files that can be directly imported in code (e.g., `import data from '@shared/static/analysis.json'`).

**Best practices for code reference**:

- Use descriptive filenames (e.g., `sales_q4_analysis.json` instead of `analysis_a1b2c3d4.json`)
- Only copy finalized, validated results to `shared/static/`
- Keep `tmp/` for iterative work; export to `shared/` only when analysis is complete
- Consider adding a `_generated` suffix or directory to distinguish from hand-written files

---

## 1. Trigger Conditions

Use this skill when the user's request involves:

- User uploads or specifies data files (CSV, Excel, JSON, Parquet, etc.)
- User requests like "分析数据", "看看数据", "统计", "找规律", "数据探索", etc.
- User asks about data quality, missing values, outliers, etc.
- User requests data insights or data reports
- User requests data visualization: "visualize", "chart", "graph", "dashboard", "plot", "可视化", "画图", "图表"
- User wants to present or display data visually (visualization inherently requires data analysis)

## 2. Analysis Methodology (6 Phases)

Follow a simplified version of the CRISP-DM methodology to ensure systematic and reproducible analysis.

### Phase 1: Business Understanding

**Goal**: Clarify the analysis purpose and avoid blind exploration.

Steps:

1. Confirm analysis type (see Section 4 "Analysis Type Quick Reference")
2. Extract the user's core question or hypothesis
3. Define success criteria: What does the user expect from the analysis?

**Output**: Record in `metadata.analysis_type` and `metadata.business_question` in JSON.

### Phase 2: Data Understanding

**Goal**: Fully understand the structure and content of the data.

Steps:

1. Load data and get basic information:
   - Row count, column count
   - Field names and data types
   - Sample rows (head/tail)
2. Identify field semantics:
   - Numeric (continuous vs discrete)
   - Categorical (ordinal vs nominal)
   - DateTime
   - Text
3. Initial statistical overview

**Python Code Template**:

```python
import pandas as pd

# Load data
df = pd.read_csv('data.csv')  # or pd.read_excel(), pd.read_json()

# Basic info
print(f"Shape: {df.shape}")
print(f"Columns: {df.columns.tolist()}")
print(f"Dtypes:\n{df.dtypes}")
print(f"Head:\n{df.head()}")
```

### Phase 3: Data Quality Assessment

**Goal**: Identify data issues to provide credibility reference for subsequent analysis.

Steps:

1. **Missing Value Analysis**:
   - Missing ratio per column
   - Missing pattern (random vs systematic)
2. **Duplicate Data Check**:
   - Fully duplicate rows
   - Key field duplicates
3. **Outlier Detection**:
   - Numeric: IQR method or Z-score
   - Categorical: Rare categories
4. **Data Consistency**:
   - Date formats
   - Category value spelling

**Python Code Template**:

```python
# Missing values
missing = df.isnull().sum()
missing_pct = (missing / len(df) * 100).round(2)
print(f"Missing values:\n{missing[missing > 0]}")

# Duplicate rows
duplicates = df.duplicated().sum()
print(f"Duplicate rows: {duplicates}")

# Numeric outliers (IQR)
def detect_outliers_iqr(series):
    Q1, Q3 = series.quantile([0.25, 0.75])
    IQR = Q3 - Q1
    lower, upper = Q1 - 1.5 * IQR, Q3 + 1.5 * IQR
    return ((series < lower) | (series > upper)).sum()

for col in df.select_dtypes(include='number').columns:
    outliers = detect_outliers_iqr(df[col])
    if outliers > 0:
        print(f"{col}: {outliers} outliers")
```

**Output**: Populate the `data_quality` section of JSON.

### Phase 4: Descriptive Analysis

**Goal**: Extract statistical characteristics and distribution patterns from the data.

#### 4.1 Numeric Variables

Metrics to compute:

- Central tendency: mean, median, mode
- Dispersion: standard deviation, variance, coefficient of variation
- Distribution shape: skewness, kurtosis
- Quantiles: Q1, Q2 (median), Q3, IQR

```python
numeric_stats = df.describe(percentiles=[0.25, 0.5, 0.75]).T
numeric_stats['skew'] = df.select_dtypes(include='number').skew()
numeric_stats['kurtosis'] = df.select_dtypes(include='number').kurtosis()
```

#### 4.2 Categorical Variables

Metrics to compute:

- Unique value count
- Frequency distribution (Top N)
- Mode

```python
for col in df.select_dtypes(include='object').columns:
    print(f"\n{col}:")
    print(f"  Unique: {df[col].nunique()}")
    print(f"  Top values:\n{df[col].value_counts().head()}")
```

#### 4.3 Correlation Analysis

For numeric variables only:

- Pearson correlation coefficient (linear relationship)
- Spearman correlation coefficient (monotonic relationship, robust to outliers)

```python
# Pearson correlation matrix
correlation_matrix = df.select_dtypes(include='number').corr(method='pearson')

# Find strong correlation pairs (|r| > 0.7)
import numpy as np
corr_pairs = []
for i in range(len(correlation_matrix.columns)):
    for j in range(i+1, len(correlation_matrix.columns)):
        r = correlation_matrix.iloc[i, j]
        if abs(r) > 0.7:
            corr_pairs.append({
                'col1': correlation_matrix.columns[i],
                'col2': correlation_matrix.columns[j],
                'correlation': round(r, 3)
            })
```

#### 4.4 Group Aggregation

When there are obvious grouping variables:

```python
# Group by category
grouped = df.groupby('category_column').agg({
    'numeric_col1': ['mean', 'std', 'count'],
    'numeric_col2': ['mean', 'std', 'count']
})
```

**Output**: Populate the `statistics` section of JSON.

### Phase 5: Insight Extraction

**Goal**: Extract business-valuable findings from statistical results.

Insight Types:

| Type | Identification Criteria | Example |
| ---- | ----------------------- | ------- |
| `correlation` | \|r\| > 0.7 or p < 0.05 | "Price and sales show strong negative correlation" |
| `trend` | Directional change in time series | "Monthly revenue shows continuous growth" |
| `anomaly` | Beyond 3σ or IQR boundary | "5 anomalous high-value orders detected" |
| `distribution` | Obvious skewness or multimodal | "Income shows right-skewed distribution" |
| `comparison` | Significant group differences | "Group A conversion rate significantly higher than Group B" |

Each insight must include:

1. **Evidence** (`evidence`): Specific data supporting the insight
2. **Significance** (`significance`): high/medium/low
3. **Affected Columns** (`affected_columns`)

### Phase 6: JSON Output (Structured Output)

**Goal**: Generate structured analysis results that conform to the specification.

After completing all analysis, output the complete JSON according to the Schema in Section 3.

---

## 3. JSON Output Specification

### Complete Schema

```json
{
  "analysis_id": "string (UUID v4)",
  "timestamp": "string (ISO 8601 format)",
  "metadata": {
    "data_source": "string (file path or data description)",
    "row_count": "integer",
    "column_count": "integer",
    "analysis_type": "exploratory | confirmatory | diagnostic | descriptive",
    "business_question": "string (user's core question, optional)"
  },
  "data_quality": {
    "completeness": "number (0-1, non-missing ratio)",
    "missing_values": {
      "column_name": "integer (missing count)"
    },
    "duplicates": "integer (duplicate row count)",
    "outliers": {
      "column_name": "integer (outlier count)"
    },
    "issues": ["string (issue description)"]
  },
  "statistics": {
    "numeric_summary": {
      "column_name": {
        "count": "integer",
        "mean": "number",
        "std": "number",
        "min": "number",
        "max": "number",
        "quartiles": ["number (Q1)", "number (Q2/median)", "number (Q3)"],
        "skew": "number (optional)",
        "kurtosis": "number (optional)"
      }
    },
    "categorical_summary": {
      "column_name": {
        "unique_count": "integer",
        "top_values": [
          {"value": "string", "count": "integer", "percentage": "number"}
        ],
        "mode": "string"
      }
    },
    "correlations": [
      {
        "column1": "string",
        "column2": "string",
        "coefficient": "number",
        "method": "pearson | spearman"
      }
    ]
  },
  "insights": [
    {
      "id": "string (insight_1, insight_2, ...)",
      "type": "correlation | trend | anomaly | distribution | comparison",
      "title": "string (short title, within 10 characters)",
      "description": "string (detailed description)",
      "evidence": {
        "metric": "string (metric name)",
        "value": "number | string",
        "p_value": "number (optional, for statistical tests)"
      },
      "significance": "high | medium | low",
      "affected_columns": ["string"]
    }
  ],
  "recommendations": [
    {
      "id": "string (rec_1, rec_2, ...)",
      "type": "visualization | further_analysis | data_collection | action",
      "title": "string (recommendation title)",
      "description": "string (detailed recommendation)",
      "priority": "high | medium | low"
    }
  ],
  "visualizations": [
    {
      "id": "string (viz_1, viz_2, ...)",
      "type": "histogram | scatter | line | bar | heatmap | box | pie",
      "title": "string (chart title)",
      "config": {
        "x": "string (X-axis field name)",
        "y": "string (Y-axis field name, optional)",
        "group_by": "string (grouping field, optional)",
        "aggregation": "string (aggregation method: sum/mean/count, optional)"
      },
      "insight_refs": ["string (associated insight id)"]
    }
  ]
}
```

### Field Description

| Field Path | Required | Description |
| ---------- | -------- | ----------- |
| `analysis_id` | Yes | Unique identifier for analysis task, use UUID v4 |
| `timestamp` | Yes | Analysis completion time, ISO 8601 format |
| `metadata.*` | Yes | Data source metadata |
| `data_quality.*` | Yes | Data quality assessment results |
| `statistics.numeric_summary` | Conditional | Required when numeric columns exist |
| `statistics.categorical_summary` | Conditional | Required when categorical columns exist |
| `statistics.correlations` | No | Only populate when significant correlations found |
| `insights` | Yes | At least 1 insight required |
| `recommendations` | Yes | At least 1 recommendation required |
| `visualizations` | Yes | At least 1 visualization config required |

### Example Output

```json
{
  "analysis_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "timestamp": "2024-01-15T10:30:00Z",
  "metadata": {
    "data_source": "/data/sales_2023.csv",
    "row_count": 10000,
    "column_count": 12,
    "analysis_type": "exploratory",
    "business_question": "了解2023年销售数据的整体情况"
  },
  "data_quality": {
    "completeness": 0.95,
    "missing_values": {
      "customer_age": 320,
      "region": 180
    },
    "duplicates": 45,
    "outliers": {
      "order_amount": 23
    },
    "issues": [
      "customer_age 列有 3.2% 缺失值",
      "order_amount 存在 23 个异常高值（超出 IQR 上界）"
    ]
  },
  "statistics": {
    "numeric_summary": {
      "order_amount": {
        "count": 10000,
        "mean": 156.78,
        "std": 89.34,
        "min": 5.00,
        "max": 2500.00,
        "quartiles": [85.00, 135.00, 210.00],
        "skew": 2.34,
        "kurtosis": 8.91
      },
      "customer_age": {
        "count": 9680,
        "mean": 35.6,
        "std": 12.3,
        "min": 18,
        "max": 75,
        "quartiles": [26, 34, 44]
      }
    },
    "categorical_summary": {
      "product_category": {
        "unique_count": 5,
        "top_values": [
          {"value": "Electronics", "count": 3500, "percentage": 35.0},
          {"value": "Clothing", "count": 2800, "percentage": 28.0},
          {"value": "Home", "count": 2000, "percentage": 20.0}
        ],
        "mode": "Electronics"
      }
    },
    "correlations": [
      {
        "column1": "order_amount",
        "column2": "customer_age",
        "coefficient": 0.72,
        "method": "pearson"
      }
    ]
  },
  "insights": [
    {
      "id": "insight_1",
      "type": "correlation",
      "title": "年龄与消费正相关",
      "description": "客户年龄与订单金额呈较强正相关（r=0.72），年长客户倾向于更高消费。",
      "evidence": {
        "metric": "pearson_correlation",
        "value": 0.72,
        "p_value": 0.001
      },
      "significance": "high",
      "affected_columns": ["customer_age", "order_amount"]
    },
    {
      "id": "insight_2",
      "type": "distribution",
      "title": "订单金额右偏分布",
      "description": "订单金额呈明显右偏（skew=2.34），大部分订单集中在低价区间，少量高价订单拉高均值。",
      "evidence": {
        "metric": "skewness",
        "value": 2.34
      },
      "significance": "medium",
      "affected_columns": ["order_amount"]
    }
  ],
  "recommendations": [
    {
      "id": "rec_1",
      "type": "further_analysis",
      "title": "深入分析高价值客户",
      "description": "建议对年龄>40且订单金额>500的客户群体进行细分分析，挖掘其消费特征。",
      "priority": "high"
    },
    {
      "id": "rec_2",
      "type": "visualization",
      "title": "绘制年龄-消费散点图",
      "description": "使用散点图可视化年龄与订单金额的关系，并按产品类别着色。",
      "priority": "medium"
    }
  ],
  "visualizations": [
    {
      "id": "viz_1",
      "type": "scatter",
      "title": "客户年龄 vs 订单金额",
      "config": {
        "x": "customer_age",
        "y": "order_amount",
        "group_by": "product_category"
      },
      "insight_refs": ["insight_1"]
    },
    {
      "id": "viz_2",
      "type": "histogram",
      "title": "订单金额分布",
      "config": {
        "x": "order_amount"
      },
      "insight_refs": ["insight_2"]
    },
    {
      "id": "viz_3",
      "type": "bar",
      "title": "各产品类别销售额",
      "config": {
        "x": "product_category",
        "y": "order_amount",
        "aggregation": "sum"
      },
      "insight_refs": []
    }
  ]
}
```

---

## 4. Analysis Type Quick Reference

Select the appropriate analysis focus based on user intent:

| User Expression | Analysis Type | Focus Phase | Key Output |
| --------------- | ------------- | ----------- | ---------- |
| "explore data", "overview", "understand data" | `exploratory` | Phase 2-4 | Basic stats, quality report, distribution |
| "find patterns", "correlations", "relationships" | `exploratory` | Phase 4.3 | Correlation matrix, significant pairs |
| "compare", "A vs B", "differences" | `diagnostic` | Phase 4.4 | Group statistics, group differences |
| "validate hypothesis", "significance test" | `confirmatory` | Phase 4-5 | Statistical tests, p-values |
| "statistics", "summary", "report" | `descriptive` | Phase 4 | Aggregation results, frequency stats |
| "trend", "changes", "time series" | `exploratory` | Phase 4 | Time series trends, periodicity |

---

## 5. Python Code Standards

### Recommended Libraries

```python
# Data processing
import pandas as pd
import numpy as np

# Statistical analysis
from scipy import stats

# Date handling
from datetime import datetime

# JSON output
import json
import uuid
```

### Complete Analysis Template

```python
import pandas as pd
import numpy as np
from scipy import stats
import json
import uuid
from datetime import datetime
from pathlib import Path

def setup_tmp_dirs(project_root: Path = None) -> dict:
    """
    Initialize tmp directory structure for analysis artifacts.

    Args:
        project_root: Project root path. Defaults to current working directory.

    Returns:
        Dict containing paths to tmp subdirectories.
    """
    if project_root is None:
        project_root = Path.cwd()

    tmp_dir = project_root / "tmp"
    paths = {
        "root": tmp_dir,
        "scripts": tmp_dir / "analysis_scripts",
        "intermediate": tmp_dir / "intermediate",
        "output": tmp_dir / "output",
        "visualizations": tmp_dir / "output" / "visualizations",
    }

    for path in paths.values():
        path.mkdir(parents=True, exist_ok=True)

    return paths


def analyze_data(file_path: str, analysis_type: str = "exploratory",
                 project_root: Path = None) -> dict:
    """
    Execute complete data analysis workflow.

    Args:
        file_path: Data file path
        analysis_type: Analysis type (exploratory/confirmatory/diagnostic/descriptive)
        project_root: Project root for tmp directory. Defaults to cwd.

    Returns:
        Analysis result JSON conforming to specification
    """
    # 0. Setup tmp directories
    tmp_paths = setup_tmp_dirs(project_root)

    # 1. Load data
    if file_path.endswith('.csv'):
        df = pd.read_csv(file_path)
    elif file_path.endswith(('.xls', '.xlsx')):
        df = pd.read_excel(file_path)
    elif file_path.endswith('.json'):
        df = pd.read_json(file_path)
    else:
        raise ValueError(f"Unsupported file format: {file_path}")

    # 2. Initialize result structure
    result = {
        "analysis_id": str(uuid.uuid4()),
        "timestamp": datetime.utcnow().isoformat() + "Z",
        "metadata": {
            "data_source": file_path,
            "row_count": len(df),
            "column_count": len(df.columns),
            "analysis_type": analysis_type
        },
        "data_quality": {},
        "statistics": {},
        "insights": [],
        "recommendations": [],
        "visualizations": []
    }

    # 3. Data quality assessment
    missing = df.isnull().sum()
    result["data_quality"] = {
        "completeness": round(1 - df.isnull().sum().sum() / df.size, 4),
        "missing_values": {k: int(v) for k, v in missing[missing > 0].items()},
        "duplicates": int(df.duplicated().sum()),
        "outliers": {},
        "issues": []
    }

    # Detect outliers
    for col in df.select_dtypes(include='number').columns:
        Q1, Q3 = df[col].quantile([0.25, 0.75])
        IQR = Q3 - Q1
        outlier_count = int(((df[col] < Q1 - 1.5 * IQR) | (df[col] > Q3 + 1.5 * IQR)).sum())
        if outlier_count > 0:
            result["data_quality"]["outliers"][col] = outlier_count

    # 4. Descriptive statistics
    # Numeric
    numeric_cols = df.select_dtypes(include='number').columns
    if len(numeric_cols) > 0:
        result["statistics"]["numeric_summary"] = {}
        for col in numeric_cols:
            series = df[col].dropna()
            result["statistics"]["numeric_summary"][col] = {
                "count": int(series.count()),
                "mean": round(float(series.mean()), 4),
                "std": round(float(series.std()), 4),
                "min": round(float(series.min()), 4),
                "max": round(float(series.max()), 4),
                "quartiles": [
                    round(float(series.quantile(0.25)), 4),
                    round(float(series.quantile(0.50)), 4),
                    round(float(series.quantile(0.75)), 4)
                ],
                "skew": round(float(series.skew()), 4),
                "kurtosis": round(float(series.kurtosis()), 4)
            }

    # Categorical
    categorical_cols = df.select_dtypes(include=['object', 'category']).columns
    if len(categorical_cols) > 0:
        result["statistics"]["categorical_summary"] = {}
        for col in categorical_cols:
            value_counts = df[col].value_counts()
            total = len(df[col].dropna())
            result["statistics"]["categorical_summary"][col] = {
                "unique_count": int(df[col].nunique()),
                "top_values": [
                    {
                        "value": str(idx),
                        "count": int(cnt),
                        "percentage": round(cnt / total * 100, 2)
                    }
                    for idx, cnt in value_counts.head(5).items()
                ],
                "mode": str(value_counts.index[0]) if len(value_counts) > 0 else None
            }

    # 5. Correlation analysis
    if len(numeric_cols) > 1:
        corr_matrix = df[numeric_cols].corr()
        correlations = []
        for i in range(len(numeric_cols)):
            for j in range(i + 1, len(numeric_cols)):
                r = corr_matrix.iloc[i, j]
                if abs(r) > 0.5:  # Keep medium+ correlations only
                    correlations.append({
                        "column1": numeric_cols[i],
                        "column2": numeric_cols[j],
                        "coefficient": round(float(r), 4),
                        "method": "pearson"
                    })
        if correlations:
            result["statistics"]["correlations"] = correlations

    # 6. Save output to tmp directory with semantic naming
    base_name = Path(file_path).stem  # e.g., "sales_2023" from "sales_2023.csv"
    output_file = tmp_paths["output"] / f"{base_name}_{analysis_type}.json"
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(result, f, indent=2, ensure_ascii=False)
    print(f"Analysis result saved to: {output_file}")

    # Optional: Save intermediate data with semantic naming
    # df_cleaned.to_csv(tmp_paths["intermediate"] / f"{base_name}_cleaned.csv", index=False)

    return result


def save_visualization(fig, viz_id: str, tmp_paths: dict, format: str = "png"):
    """
    Save matplotlib/seaborn figure to tmp/output/visualizations.

    Args:
        fig: matplotlib figure object
        viz_id: Visualization ID (e.g., "viz_1")
        tmp_paths: Dict from setup_tmp_dirs()
        format: Image format (png, svg, pdf)
    """
    output_path = tmp_paths["visualizations"] / f"{viz_id}.{format}"
    fig.savefig(output_path, dpi=150, bbox_inches='tight')
    print(f"Visualization saved to: {output_path}")
    return output_path


# Usage example
# result = analyze_data("sales_2023.csv", "exploratory")
# print(json.dumps(result, indent=2, ensure_ascii=False))
# # Output: tmp/output/sales_2023_exploratory.json
#
# # Save visualization with semantic naming
# import matplotlib.pyplot as plt
# fig, ax = plt.subplots()
# ax.scatter(df['age'], df['amount'])
# save_visualization(fig, "sales_2023_age_vs_amount", tmp_paths)
# # Output: tmp/output/visualizations/sales_2023_age_vs_amount.png
```

---

## 6. Common Mistakes and Correct Approaches

| Mistake | Correct Approach |
| ------- | ---------------- |
| Analyze directly without checking data quality | Execute Phase 3 first, assess missing values and outliers |
| Ignore missing values when calculating mean | Clarify missing value handling strategy, or use `dropna()` |
| Interpret correlation as causation | Explicitly label "correlation" not "causes" in insights |
| Ignore data types and analyze directly | Confirm dtype first, numeric vs categorical need different handling |
| Output non-standardized JSON | Strictly follow the Schema in Section 3 |
| Insights without supporting evidence | Every insight must have an `evidence` field |
| Visualization config doesn't match data | Ensure field names in `config` exist in the data |

---

## 7. Quality Checklist

Before completing analysis and outputting JSON, confirm the following:

- [ ] **tmp/ directory initialized**: All subdirectories created
- [ ] **Data quality assessed**: `data_quality` section fully populated
- [ ] **Statistics complete**: All numeric/categorical columns have corresponding summary
- [ ] **Insights have evidence**: Every insight has an `evidence` field
- [ ] **Insights answer business question**: Corresponds to `metadata.business_question`
- [ ] **JSON conforms to spec**: Field names, types, required fields all correct
- [ ] **Visualization config is valid**: Field names in `config` exist in the data
- [ ] **At least 1 recommendation**: `recommendations` is not empty
- [ ] **No hardcoded paths**: File paths come from user input
- [ ] **Outputs saved to tmp/**: JSON result and visualizations written to correct locations
- [ ] **tmp/ in .gitignore**: Ensure tmp/ is excluded from version control

---

## 8. Execution Flow

When this skill is triggered, execute in the following order:

1. **Setup tmp directory**: Initialize `tmp/` directory structure in project root
2. **Confirm data source**: Confirm the file path to analyze with user
3. **Execute Phase 1-3**: Business Understanding → Data Understanding → Quality Assessment
4. **Report initial findings**: Inform user about data overview and quality issues
5. **Execute Phase 4-5**: Descriptive Analysis → Insight Extraction
6. **Generate JSON output**: Save structured result to `tmp/output/`
7. **Generate visualizations** (optional): Save charts to `tmp/output/visualizations/`
8. **Update AGENTS.md**: Record analysis summary in project's AGENTS.md file
9. **Report output locations**: Inform user where artifacts are saved

### Output Summary Template

After completing analysis, report to user:

```text
Analysis complete! Artifacts saved to:

📁 tmp/
├── output/
│   ├── sales_2023_exploratory.json      # Structured analysis result
│   └── visualizations/
│       ├── sales_2023_age_vs_amount.png # Scatter plot
│       └── sales_2023_amount_dist.png   # Histogram
└── intermediate/
    └── sales_2023_cleaned.csv           # Cleaned data (if applicable)

To use in your code, copy the JSON to shared/static/:
  cp tmp/output/sales_2023_exploratory.json shared/static/

Then import directly in your code:
  import analysisData from '@shared/static/sales_2023_exploratory.json'
```

### Updating AGENTS.md

After completing analysis, append a brief record to the project's `AGENTS.md` file. This helps track what analyses have been performed and where results are stored.

**Format**:

```markdown
## Data Analysis Log

### [Date] Analysis of [filename]
- **Source file**: `path/to/source/data.csv`
- **Analysis type**: exploratory | confirmatory | diagnostic | descriptive
- **Key findings**: Brief summary of main insights (1-2 sentences)
- **Output location**: `tmp/output/filename_analysis.json`
- **Copied to**: `shared/static/filename_analysis.json` (if applicable)
```

**Example entry**:

```markdown
### 2024-01-15 Analysis of sales_2023.csv
- **Source file**: `data/sales_2023.csv`
- **Analysis type**: exploratory
- **Key findings**: Strong correlation between customer age and order amount (r=0.72). Order amounts show right-skewed distribution.
- **Output location**: `tmp/output/sales_2023_exploratory.json`
- **Copied to**: `shared/static/sales_2023_exploratory.json`
```
