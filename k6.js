import http from 'k6/http';
export const options = {
  stages: [
    { duration: '100s', target: 500 },
  ],
};


export default function () {
  for (let id = 1; id <= 100; id++) {
    http.get("http://krakend_ce:8080/api/v2/stores");
  }
}
