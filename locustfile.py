from locust import HttpLocust, TaskSet, task

import resource

resource.setrlimit(resource.RLIMIT_NOFILE, (3000, 3000))

f = open('generated_testdata.txt')
datapoints_250 = f.read()
f.close()

class UserBehavior(TaskSet):
  def on_start(self):
    self.query1 = {"q": "select * from temperature where (device_id = '10001' or device_id = '10002' or device_id = '10003' or device_id = '10004' or device_id = '10005') and time > now() - 6h",
                    "db": "load_testing"}
    self.query2 = {"q": "select last(value) from /.*/ where time > NOW() - 1m group by *",
                    "db": "load_testing"}
    self.datapoint_temperature = 'temperature,device_id=20002 value=23.5'

  @task(1)
  def get_latest_data(self):
    self.client.get("/query", params=self.query1,
                              name="Select 6h of data from temperature for 5 devices")
  @task(1)
  def get_latest_data_for_all_devices(self):
    self.client.get("/query", params=self.query2,
                              name= "Select last value from all measurements for all devices")

  @task(100)
  def write_one_measurement_for_one_device(self):
    self.client.post("/write",  data=self.datapoint_temperature,
                                params="db=load_testing",
                                headers={'Content-Type': 'application/octet-stream'},
                                name="Write one measurement for one device")

  @task(100)
  def write_250_measurements_to_all_series(self):
    self.client.post("/write",  data=datapoints_250,
                                params="db=load_testing",
                                headers={'Content-Type': 'application/octet-stream'},
                                name="Write 250 measurements across 7 series")

class WebsiteUser(HttpLocust):
    task_set = UserBehavior
    min_wait=1000
    max_wait=3000
