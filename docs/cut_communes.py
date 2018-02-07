import csv
from collections import defaultdict

source_file = "communes_gps.csv"
dest_file   = "communes_gps_vosges.csv"


with open(source_file, 'rb') as csvfile:
    header = next(csvfile).strip("\n").split(";")
    print header
    print header[4]
    reader = csv.reader(csvfile, delimiter=';')
    ### Filtrage des codes APE
    results = filter(lambda row: row[4] == '88' or
                                 row[4] == 88, reader)
    ### Ou bien filtrage par code ESS :
    # results = filter(lambda row: row[76] == 'O', reader)


with open(dest_file, 'wb') as outfile:
    writer = csv.writer(outfile, delimiter=';')
    writer.writerow(header)
    for result in results:
        writer.writerow(result)

