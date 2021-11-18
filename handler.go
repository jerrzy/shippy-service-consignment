package main

import (
	"context"
	"log"

	pb "github.com/jerrzy/shippy-service-consignment/proto/consignment"
	vesselProto "github.com/jerrzy/shippy-service-vessel/proto/vessel"
	"github.com/pkg/errors"
)

type handler struct {
	repository
	vesselClient vesselProto.VesselService
}

// CreateConsignment - we created just one method on our service,
// which is a create method, which takes a context and a request as an
// argument, these are handled by the gRPC server.
func (s *handler) CreateConsignment(ctx context.Context, req *pb.Consignment, res *pb.Response) error {

	// Here we call a client instance of our vessel service with our consignment weight,
	// and the amount of containers as the capacity value
	vesselResponse, err := s.vesselClient.FindAvailable(ctx, &vesselProto.Specification{
		MaxWeight: req.Weight,
		Capacity:  int32(len(req.Containers)),
	})

	if vesselResponse == nil {
		log.Printf("No matching vessel found \n")
		return errors.New("No matching vessel found, returned nil")
	}

	if err != nil {
		log.Println("Error fetching vessel: ", err)
		return err
	}

	log.Printf("Vessel found: %v \n", vesselResponse)

	// We set the VesselId as the vessel we got back from our
	// vessel service
	req.VesselId = vesselResponse.Vessel.Id

	// Save our consignment
	err = s.repository.Create(ctx, MarshalConsignment(req))
	if err != nil {
		return err
	}

	res.Created = true
	res.Consignment = req
	return nil
}

// GetConsignments -
func (s *handler) GetConsignments(ctx context.Context, req *pb.GetRequest, res *pb.Response) error {
	// consignments, err := s.repository.GetAll(ctx)
	consignments, err := s.repository.GetAll(ctx)
	if err != nil {
		return err
	}
	res.Consignments = UnmarshalConsignmentCollection(consignments)
	return nil
}
