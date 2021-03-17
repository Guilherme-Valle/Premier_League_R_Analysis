import pandas as pd

if __name__ == '__main__':
    filenames = []
    for num in range(1, 30):
        filenames.append("~/Documents/Datasets/England/eng.1 "+str(num)+".csv")
    combined_csv = pd.concat([ pd.read_csv(f) for f in filenames ])
    combined_csv.to_csv("~/Documents/Datasets/England/combined_csv.csv", index=False)


