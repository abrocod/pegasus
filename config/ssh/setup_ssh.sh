#!/bin/bash

# Copyright 2015 Insight Data Science
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

SLAVE_DNS=( "$@" )

if ! [ -f ~/.ssh/id_rsa ]; then
    ssh-keygen -f ~/.ssh/id_rsa -t rsa -P ""
fi
sudo cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# copy id_rsa.pub in master to all slaves authorized_keys for passwordless ssh
# add additional for multiple slaves
for dns in ${SLAVE_DNS[@]}
do
  echo "Adding $DNS to authorized keys..."
  cat ~/.ssh/id_rsa.pub | ssh -o "StrictHostKeyChecking no" ${USER}@$dns 'cat >> ~/.ssh/authorized_keys' &
done

wait
