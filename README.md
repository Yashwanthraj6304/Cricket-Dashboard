This dataset collection contains career statistics and pitch-specific performance records for cricket players. It is suitable for exploratory data analysis, SQL practice, data visualization, dashboard development, and introductory sports analytics projects.

## Dataset Files

| File | Rows | Columns | Description |
| --- | ---: | ---: | --- |
| `player_statistics_5000_cleaned(6).csv` | 5,000 | 10 | Player identity, nationality, role, format-wise runs, wickets, half-centuries, and centuries |
| `players_pitch_performance_5000_cleaned(5).csv` | 5,000 | 8 | Runs and dismissals recorded across flat, red-soil, and black-soil pitches |

## Data Dictionary

### Player Statistics

| Column | Type | Description |
| --- | --- | --- |
| `S.no` | Integer | Row serial number |
| `Player Name` | Text | Name of the player |
| `Nationality` | Text | Player's country or `Not available` when nationality is unknown |
| `Role` | Category | Playing role: `Batsman`, `Bowler`, or `All-rounder` |
| `Test Runs` | Integer | Runs scored in Test cricket |
| `ODI Runs` | Integer | Runs scored in One Day Internationals |
| `T20 Runs` | Integer | Runs scored in T20 cricket |
| `Wickets` | Integer | Total wickets recorded |
| `No. of 50's` | Integer | Number of half-centuries |
| `No. of 100's` | Integer | Number of centuries |

### Pitch Performance

| Column | Type | Description |
| --- | --- | --- |
| `S.no` | Integer | Row serial number |
| `Player Name` | Text | Name of the player |
| `Runs in Flat Pitches` | Integer | Runs scored on flat pitches |
| `Runs in Red Soil Pitches` | Integer | Runs scored on red-soil pitches |
| `Runs in Black Soil Pitches` | Integer | Runs scored on black-soil pitches |
| `Dismissals in Flat Pitches` | Integer | Dismissals on flat pitches |
| `Dismissals in Red Soil Pitches` | Integer | Dismissals on red-soil pitches |
| `Dismissals in Black Soil Pitches` | Integer | Dismissals on black-soil pitches |

## Data Quality Summary

- Both files contain 5,000 data rows.
- No empty cells or completely duplicated rows were found.
- `player_statistics_5000_cleaned(6).csv` contains 4,971 unique player names; 25 names occur more than once.
- `players_pitch_performance_5000_cleaned(5).csv` contains 5,000 unique player names.
- The files share 3,320 unique player names.
- The statistics file contains 2,386 rows where nationality is `Not available`.
- All measured statistics are non-negative integers, and zero can represent no recorded runs, dismissals, wickets, fifties, or hundreds.

## Important Join Note

Do **not** join the files using `S.no`. The serial numbers are row identifiers, and only 3 positions contain the same player in both files. Use a normalized `Player Name` as the candidate join key and inspect duplicate names before merging. A name alone may not uniquely identify a real person.

Example using pandas:

```python
import pandas as pd

stats = pd.read_csv("player_statistics_5000_cleaned(6).csv")
pitch = pd.read_csv("players_pitch_performance_5000_cleaned(5).csv")

for df in (stats, pitch):
    df["player_key"] = (
        df["Player Name"]
        .str.strip()
        .str.lower()
        .str.replace(r"\s+", " ", regex=True)
    )

# Review ambiguous names before joining.
duplicates = stats[stats.duplicated("player_key", keep=False)]
print(duplicates.sort_values("player_key"))

combined = stats.merge(
    pitch,
    on="player_key",
    how="inner",
    suffixes=("_stats", "_pitch"),
    validate="many_to_one",
)
```

## Example Analysis Ideas

- Compare Test, ODI, and T20 run totals by player or nationality.
- Find the leading run scorers, wicket takers, and century makers.
- Compare the distribution of batsmen, bowlers, and all-rounders.
- Identify the pitch type on which each player scores the most runs.
- Calculate pitch-specific batting averages as `runs / dismissals`, while handling zero dismissals.
- Build interactive filters for player, nationality, role, and pitch type.
- Study correlations among runs, wickets, half-centuries, and centuries.

## Quick Start

```python
import pandas as pd

stats = pd.read_csv("player_statistics_5000_cleaned(6).csv")
pitch = pd.read_csv("players_pitch_performance_5000_cleaned(5).csv")

print(stats.info())
print(stats.describe())
print(pitch.describe())
```

Example pitch-average calculation:

```python
pitch["Flat Pitch Average"] = (
    pitch["Runs in Flat Pitches"]
    .div(pitch["Dismissals in Flat Pitches"].replace(0, pd.NA))
)
```

## Recommended Tools

- **Python:** pandas, NumPy, Matplotlib, Seaborn, Plotly
- **Databases:** PostgreSQL, MySQL, 
- **Dashboards:** chatgpt ai ,claude, tableau
- **Development:** Jupyter Notebook or Visual Studio Code

## Limitations

- The data does not include match dates, teams, opponents, venues, or source references.
- Career totals and pitch-specific totals may represent different scopes and should not be assumed to reconcile exactly.
- Player names may use different formats, such as initials versus full names.
- Duplicate names in the statistics file can cause one-to-many matches.
- Missing nationality is stored as text rather than a null value.
- Treat the collection as a cleaned analytics/practice dataset unless its values are independently validated against an authoritative cricket source.

## License and Attribution

No license or original data source was supplied with the files. Before redistributing or using the dataset commercially, confirm the ownership, permitted use, and attribution requirements with the dataset provider.
