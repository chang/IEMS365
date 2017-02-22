import urllib.request
import requests
import os
import pandas as pd

API_KEY = "GojQVRt4gG8TgWdb"

def get_subjects(key, term_id):
	"""
	retrieves a list of all subject symbols from a term
	"""
	params = {"key": key, "term":term_id}
	response = requests.get(url='http://api.asg.northwestern.edu/subjects/', params=params)
	subjects = []
	for sub in response.json():
		subjects.append(sub['symbol'])
	return subjects


def get_courses(key, term_id, subject):
	"""
	retrieves a list of dicts of all courses from a subject or list of subjects
	"""
	if isinstance(subject, str):
		params = {
			"key": key,
			"term": term_id,  # 2017 Spring: 4660
			"subject": subject
		}
		return requests.get(url='http://api.asg.northwestern.edu/courses/', params=params).json()
	elif isinstance(subject, list):
		courses = []
		for i,sub in enumerate(subject):
			params = {
				"key": key,
				"term": term_id,
				"subject": sub
			}
			response = requests.get(url='http://api.asg.northwestern.edu/courses/', params=params)
			courses = courses + response.json()
			if i % 10 == 0:
				print("Grabbed", str(i), "of", str(len(subject)), "courses.")
		return courses


if __name__ == "__main__":

	API_KEY = "GojQVRt4gG8TgWdb"
	TERM = 4660

	subjects = get_subjects(API_KEY, TERM)
	all_courses = get_courses(API_KEY, TERM, subjects)
	pd.DataFrame(all_courses).to_csv("all_course_data.csv")

	# courses_geneng = pd.DataFrame(get_courses(API_KEY, TERM, "GEN_ENG"))
	# courses_geneng.to_csv("course_gen_eng.csv")











