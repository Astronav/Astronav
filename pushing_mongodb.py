import csv, sys
local_path = 'C:\Python\Python35\Lib\site-packages'
sys.path.append(local_path)
import pymongo

def uprint(*objects, sep=' ', end='\n', file=sys.stdout):
    enc = file.encoding
    if enc == 'UTF-8':
        print(*objects, sep=sep, end=end, file=file)
    else:
        f = lambda obj: str(obj).encode(enc, errors='backslashreplace').decode(enc)
        print(*map(f, objects), sep=sep, end=end, file=file)

def push_mongodb(csv_filename, collection_name):
#import data from csv into mongodb
        team_count = 0
        team_list = []
        header = []
        with open(csv_filename, 'rt', encoding="utf8") as f:
                reader = csv.reader(f)

                for row in reader:
                        team_info = {}
                        if team_count == 0:
                                header = row
                        else:
                                for i in range(len(header)):
                                        # if header[i] == "track":
                                        #         track_entry = row[[header[i]]
                                        #         print(track_entry)
                                        #         if not track_entry:
                                        #                 row[header[i]] = "Unlabeled"

                                        team_info.update({header[i]: row[i]})

                                team_list.append(team_info)

                        team_count += 1
                        uprint(team_list)
                        print(len(team_list))

        # connect to mongodb
        db_user = "wyattshapiro"
        db_password = "helloworld"
        db_name = "astronav-practice"

        mongodb_uri = "mongodb://" + db_user + ":" + db_password + "@ds117899.mlab.com:17899/" + db_name
        client = pymongo.MongoClient(mongodb_uri)
        db = client[db_name]

        collection = db[collection_name]

        #post each team info to mongodb
        for entry in team_list:
                collection.insert_one(entry)

# post team info
team_csv = "team_info_short.csv"
team_collection = "team_info_short"
push_mongodb(team_csv, team_collection)

# post room setup
table_csv = "table_info_short.csv"
table_collection = "table_info_short"
push_mongodb(table_csv, table_collection)
