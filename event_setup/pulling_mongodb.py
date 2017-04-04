import sys, csv
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

def get_info_by_table_number(table_number, collection_name):
        # connect to mongodb
        db_user = "wyattshapiro"
        db_password = "helloworld"
        db_name = "astronav-practice"

        mongodb_uri = "mongodb://" + db_user + ":" + db_password + "@ds117899.mlab.com:17899/" + db_name
        client = pymongo.MongoClient(mongodb_uri)
        db = client[db_name]

        collection = db[collection_name]

        # get results for that table_number
        result = collection.find_one({"table_number": table_number})

        return result

error_count = 0
none_count = 0
team_info_list = []
table_number = "1"
while True:
        # pull team and table info from mongodb

        team_info = get_info_by_table_number(table_number, "penn_apps_team_info_short")
        table_info = get_info_by_table_number(table_number, "penn_apps_table_info_short")
        if (team_info and table_info):

        #try:
                # update dictionary to include table info
                team_info.update(table_info)

                # create list of dicts of team info
                team_info_list.append(team_info)

                # if there are not more tables assigned stop data


                #print(none_count)
                #print()



        else:
        #except Exception as e:
                #del team_info_list[-1]
                #uprint(len(team_info_list))
                #print(e)
                error_count += 1
                if (error_count > 20):
                        break
                else:
                        pass

        # update table_number
        table_number = int(table_number)+1
        table_number = str(table_number)

keys = team_info_list[0].keys()
with open("master_info.csv", "wt", newline='') as output_file:
       dict_writer = csv.DictWriter(output_file, keys)
       dict_writer.writeheader()
       dict_writer.writerows(team_info_list)
