#!/bin/bash
bundle exec sidekiq -q default,2 -q carrierwave
