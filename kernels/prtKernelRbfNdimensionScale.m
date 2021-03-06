classdef prtKernelRbfNdimensionScale < prtKernelRbf
    % prtKernelRbfNdimensionScale  Auto-scale radial basis function kernel
    %
    %  kernelObj = prtKernelRbfNdimensionScale generates a
    %  prtKenrelNdimensionScale object implementing a radial basis
    %  function, but with sigma parameter scaled by the number of features
    %  in the training data set.  Kernel objects are widely used in several
    %  prt classifiers, such as prtClassRvm and prtClassSvm.  RBF kernels
    %  implement the following function for 1 x N vectors x1 and x2:
    %
    %   k(x1,x2) = exp(-sum((x1-x2).^2)./(sigma^2*N));
    %
    %  KERNOBJ = prtKernelRbfNdimensionScale(PROPERTY1, VALUE1, ...) constructs a
    %  prtKernelRbfNdimensionScale object KERNOBJ with properties as specified by
    %  PROPERTY/VALUE pairs. prtKernelRbfNdimensionScale objects have the following
    %  user-settable properties:
    %
    %   sigma   - Positive scalar value specifying the width of the
    %             Gaussian kernel in the RBF function.  (Default value is 1 )
    %             This is further scaled by the square root of the number
    %             of dimensions of the data.
    %
    %  Radial basis function kernels are widely used in the machine
    %  learning literature. For more information on these kernels, please
    %  refer to:
    %   
    %  http://en.wikipedia.org/wiki/Support_vector_machine#Non-linear_classification
    %
    %   prtKernelRbfNdimensionScale objects inherit the TRAIN, RUN, and AND
    %   methods from prtKernel.
    %
    %  Radial basis function kernels are widely used in the machine
    %  learning literature. Auto-scaling these kernels allows for relative
    %  invariance to the number of dimensions of the data under
    %  consideration.  For more information on these kernels, please refer
    %  to:
    %   
    %  http://en.wikipedia.org/wiki/Support_vector_machine#Non-linear_classification
    %
    %  % Example:
    %   ds = prtDataGenBimodal;            % Load a data set
    %   k1 = prtKernelRbfNdimensionScale;  % Create two
    %                                      % prtKernelRbfNdimensionScale
    %                                      % objects
    %   k2 = prtKernelRbfNdimensionScale('sigma',2);
    %   
     %   k1 = k1.train(ds); % Train
    %   g1 = k1.run(ds);    % Evaluate
    %
    %   k2 = k2.train(ds); % Train
    %   g2 = k2.run(ds);   % Evaluate
    %
    %   subplot(2,1,1); imagesc(g1.getObservations);  %Plot the results
    %   subplot(2,1,2); imagesc(g2.getObservations);
    %
    %   See also: prtKernel,prtKernelSet, prtKernelDc, prtKernelDirect,
    %   prtKernelHyperbolicTangent, prtKernelPolynomial,
    %   prtKernelRbf 







    methods
        function Obj = prtKernelRbfNdimensionScale(varargin)
            Obj = prtUtilAssignStringValuePairs(Obj,varargin{:});
        end
    end
    
    methods (Access = protected, Hidden = true)
        function dsOut = runAction(Obj,ds)
            if ~Obj.isTrained
                error('prtKernelRbf:run','Attempt to run an untrained kernel; use kernel.train(ds) to train');
            end
            
            if Obj.internalDataSet.nObservations == 0
                dsOut = prtDataSetClass;
            else
                scaledSigma = sqrt(Obj.sigma.^2*Obj.internalDataSet.nFeatures);
                gram = Obj.kernelFn(ds.getObservations,Obj.internalDataSet.getObservations,scaledSigma);
                dsOut = ds.setObservations(gram);
            end
        end
    end
end
